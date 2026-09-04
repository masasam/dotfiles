#!/usr/bin/env python3
"""Temporarily move a window from a numbered workspace to the current one."""

from __future__ import annotations

import argparse
import fcntl
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any

APP_NAME = "hypr-ctl-alt-workspace"


class HyprctlError(RuntimeError):
    """Raised when Hyprland state cannot be queried or changed."""


def run_hyprctl(*arguments: str) -> str:
    """Run hyprctl with ARGUMENTS and return its standard output."""
    try:
        result = subprocess.run(
            ["hyprctl", *arguments],
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as error:
        raise HyprctlError("hyprctl is not installed") from error
    except subprocess.CalledProcessError as error:
        detail = (error.stderr or error.stdout or "unknown error").strip()
        raise HyprctlError(f"hyprctl {' '.join(arguments)} failed: {detail}") from error
    return result.stdout


def query_json(command: str) -> Any:
    """Return decoded JSON for a hyprctl COMMAND."""
    try:
        return json.loads(run_hyprctl("-j", command))
    except json.JSONDecodeError as error:
        raise HyprctlError(f"hyprctl returned invalid JSON for {command}") from error


def dispatch(expression: str) -> None:
    """Run a Hyprland Lua dispatcher EXPRESSION."""
    run_hyprctl("dispatch", expression)


def move_window(workspace: int | str, address: str, *, follow: bool) -> None:
    """Move ADDRESS to WORKSPACE using Hyprland's Lua dispatcher API."""
    if not re.fullmatch(r"0x[0-9a-fA-F]+", address):
        raise HyprctlError(f"invalid window address: {address!r}")

    if isinstance(workspace, int):
        workspace_expression = str(workspace)
    elif re.fullmatch(r"(?:[1-9][0-9]*|special:[A-Za-z0-9_.-]+)", workspace):
        workspace_expression = json.dumps(workspace)
    else:
        raise HyprctlError(f"invalid workspace selector: {workspace!r}")

    follow_expression = "true" if follow else "false"
    dispatch(
        "hl.dsp.window.move({ "
        f"workspace = {workspace_expression}, "
        f"follow = {follow_expression}, "
        f'window = "address:{address}" '
        "})"
    )


def swap_window(direction: str) -> None:
    """Swap the active window in DIRECTION using Hyprland's Lua API."""
    directions = {"l": "left", "r": "right"}
    if direction not in directions:
        raise HyprctlError(f"invalid swap direction: {direction!r}")
    dispatch(
        f'hl.dsp.window.swap({{ direction = "{directions[direction]}" }})'
    )


def state_directory() -> Path:
    """Return the private runtime directory used for borrowed-window state."""
    runtime_root = Path(
        os.environ.get("XDG_RUNTIME_DIR", f"/tmp/hypr-runtime-{os.getuid()}")
    )
    directory = runtime_root / APP_NAME
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    return directory


def read_state(path: Path) -> dict[str, Any] | None:
    """Read state from PATH, removing invalid state."""
    if not path.exists():
        return None
    try:
        state = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(state, dict):
            raise TypeError("state is not a JSON object")
        if not isinstance(state.get("address"), str):
            raise TypeError("missing window address")
        if not isinstance(state.get("workspace"), str):
            raise TypeError("missing workspace")
        return state
    except (OSError, json.JSONDecodeError, TypeError) as error:
        path.unlink(missing_ok=True)
        raise HyprctlError(f"discarded invalid state in {path}: {error}") from error


def write_state(path: Path, state: dict[str, Any]) -> None:
    """Atomically write STATE to PATH."""
    descriptor, temporary_name = tempfile.mkstemp(dir=path.parent, prefix="state-")
    temporary_path = Path(temporary_name)
    try:
        with os.fdopen(descriptor, "w", encoding="utf-8") as stream:
            json.dump(state, stream)
            stream.write("\n")
        os.chmod(temporary_path, 0o600)
        temporary_path.replace(path)
    finally:
        temporary_path.unlink(missing_ok=True)


def matching_clients(
    clients: list[dict[str, Any]], workspace: str
) -> list[dict[str, Any]]:
    """Return mapped clients which belong to WORKSPACE."""
    matches = []
    for client in clients:
        client_workspace = client.get("workspace")
        if (
            client.get("mapped", True)
            and isinstance(client_workspace, dict)
            and client_workspace.get("name") == workspace
            and isinstance(client.get("address"), str)
        ):
            matches.append(client)
    return matches


def restore_window(
    state_path: Path, state: dict[str, Any], clients: list[dict[str, Any]]
) -> None:
    """Move the previously borrowed window back to its source workspace."""
    address = state["address"]
    if not any(client.get("address") == address for client in clients):
        state_path.unlink(missing_ok=True)
        raise HyprctlError("the borrowed window no longer exists; stale state removed")

    move_window(state["workspace"], address, follow=False)
    state_path.unlink(missing_ok=True)


def borrow_window(
    number: int,
    state_path: Path,
    active_workspace: dict[str, Any],
    clients: list[dict[str, Any]],
) -> None:
    """Move the window assigned to NUMBER into ACTIVE_WORKSPACE."""
    source_workspace = "special:magic" if number == 0 else str(number)
    current_id = active_workspace.get("id")
    current_name = str(active_workspace.get("name", ""))
    window_count = active_workspace.get("windows")

    if not current_name:
        raise HyprctlError("the active workspace has no name")
    if not isinstance(current_id, int):
        raise HyprctlError("the active workspace has no numeric ID")
    if number != 0 and current_name == source_workspace:
        return
    if window_count != 1:
        raise HyprctlError(
            f"workspace {current_name} must contain exactly one window, found {window_count}"
        )

    candidates = matching_clients(clients, source_workspace)
    if len(candidates) != 1:
        raise HyprctlError(
            f"workspace {source_workspace} must contain exactly one window, "
            f"found {len(candidates)}"
        )

    client = candidates[0]
    address = client["address"]
    write_state(
        state_path,
        {
            "address": address,
            "pid": client.get("pid"),
            "workspace": source_workspace,
        },
    )
    try:
        move_window(current_id, address, follow=True)
    except (HyprctlError, OSError):
        state_path.unlink(missing_ok=True)
        raise

    if number == 0 or current_id < number:
        swap_window("r")
    elif current_id > number:
        swap_window("l")


def toggle_workspace_window(number: int) -> None:
    """Borrow or restore the window assigned to workspace NUMBER."""
    directory = state_directory()
    state_path = directory / f"{number}.json"
    lock_path = directory / f"{number}.lock"

    with lock_path.open("w", encoding="utf-8") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        active_workspace = query_json("activeworkspace")
        clients = query_json("clients")
        if not isinstance(active_workspace, dict) or not isinstance(clients, list):
            raise HyprctlError("unexpected Hyprland JSON response")

        state = read_state(state_path)
        if state is not None:
            restore_window(state_path, state, clients)
        else:
            borrow_window(number, state_path, active_workspace, clients)


def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workspace", type=int, choices=range(10))
    return parser.parse_args()


def notify_error(message: str) -> None:
    """Report MESSAGE to stderr and to the desktop notification service."""
    print(f"{APP_NAME}: {message}", file=sys.stderr)
    try:
        subprocess.run(
            ["notify-send", "Hyprland window toggle", message],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except FileNotFoundError:
        pass


def main() -> int:
    """Run the command-line program."""
    arguments = parse_arguments()
    try:
        toggle_workspace_window(arguments.workspace)
    except (HyprctlError, OSError) as error:
        notify_error(str(error))
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
