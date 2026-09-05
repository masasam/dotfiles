#!/usr/bin/env python3
from __future__ import annotations

import html
import json
import os
import string
import subprocess
import sys
from pathlib import Path
from typing import Any


def env_int(name: str, default: int) -> int:
    try:
        return int(os.environ.get(name, str(default)))
    except ValueError:
        return default


MAX_CHARS = max(80, env_int("CODEX_NOTIFY_MAX_CHARS", 240))
DONE_TIMEOUT = max(1000, env_int("CODEX_NOTIFY_TIMEOUT_MS", 7000))
APPROVAL_TIMEOUT = max(1000, env_int("CODEX_NOTIFY_APPROVAL_TIMEOUT_MS", 12000))
ICON = Path.home() / ".config/mako/icons/ChatGPT.png"
ONLY_WHEN_UNFOCUSED = os.environ.get(
    "CODEX_NOTIFY_ONLY_WHEN_UNFOCUSED", "1"
).lower() not in {"0", "false", "no", "off"}


def compact(text: str | None, limit: int = MAX_CHARS) -> str:
    if not text:
        return ""
    clean = " ".join(str(text).split())
    if len(clean) <= limit:
        return clean
    return clean[: max(1, limit - 1)].rstrip() + "…"


def project_name(cwd: str | None) -> str:
    if not cwd:
        return "Codex"
    root = ""
    returncode = 1
    try:
        p = subprocess.run(
            ["git", "-C", cwd, "rev-parse", "--show-toplevel"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        root = p.stdout.strip()
        returncode = p.returncode
    except (OSError, subprocess.TimeoutExpired):
        root = ""
    if returncode == 0 and root:
        return Path(root).name
    try:
        return Path(cwd).resolve().name or "Codex"
    except (OSError, RuntimeError):
        return "Codex"


def which(name: str) -> str | None:
    for directory in os.environ.get("PATH", "").split(os.pathsep):
        candidate = Path(directory) / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def parent_pids(pid: int) -> set[int]:
    return set(parent_pid_chain(pid))


def parent_pid_chain(pid: int) -> list[int]:
    """Return PID and its ancestors, ordered from nearest to farthest."""
    result: list[int] = []
    current = pid
    seen: set[int] = set()
    for _ in range(64):
        if current <= 1 or current in seen:
            break
        seen.add(current)
        result.append(current)
        try:
            stat = Path(f"/proc/{current}/stat").read_text()
            after_comm = stat.rsplit(")", 1)[1].strip().split()
            current = int(after_comm[1])
        except (IndexError, OSError, ValueError):
            break
    if current > 0 and current not in seen:
        result.append(current)
    return result


def valid_window_address(value: object) -> bool:
    if not isinstance(value, str) or not value.startswith("0x"):
        return False
    digits = value[2:]
    return bool(digits) and all(character in string.hexdigits for character in digits)


def find_terminal_window(
    clients: object, pid_chain: list[int]
) -> tuple[str, int] | None:
    if not isinstance(clients, list):
        return None
    clients_by_pid: dict[int, str] = {}
    for client in clients:
        if not isinstance(client, dict):
            continue
        try:
            pid = int(client.get("pid"))
        except (TypeError, ValueError):
            continue
        address = client.get("address")
        if valid_window_address(address):
            clients_by_pid[pid] = address
    for pid in pid_chain:
        if address := clients_by_pid.get(pid):
            return address, pid
    return None


def parse_tmux_clients(output: str, session: str) -> list[int]:
    """Return clients attached to SESSION, most recently active first."""
    clients: list[tuple[int, int]] = []
    for line in output.splitlines():
        fields = line.split("\t")
        if len(fields) != 3 or fields[1] != session:
            continue
        try:
            clients.append((int(fields[2]), int(fields[0])))
        except ValueError:
            continue
    clients.sort(reverse=True)
    return [pid for _, pid in clients]


def tmux_client_pids() -> list[int]:
    """Find terminal-side tmux clients for the pane running Codex."""
    pane = os.environ.get("TMUX_PANE")
    if not os.environ.get("TMUX") or not pane or not which("tmux"):
        return []
    try:
        session_process = subprocess.run(
            ["tmux", "display-message", "-p", "-t", pane, "#{session_name}"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        if session_process.returncode != 0:
            return []
        session = session_process.stdout.strip()
        clients_process = subprocess.run(
            [
                "tmux",
                "list-clients",
                "-F",
                "#{client_pid}\t#{client_session}\t#{client_activity}",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        if clients_process.returncode != 0:
            return []
        return parse_tmux_clients(clients_process.stdout, session)
    except (OSError, subprocess.TimeoutExpired):
        return []


def codex_terminal_window() -> tuple[str, int] | None:
    if not os.environ.get("HYPRLAND_INSTANCE_SIGNATURE") or not which("hyprctl"):
        return None
    try:
        process = subprocess.run(
            ["hyprctl", "clients", "-j"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        if process.returncode != 0:
            return None
        clients = json.loads(process.stdout)
        # Direct shells have the compositor window in their ancestor chain.
        # Inside tmux, pane processes instead descend from the tmux server, so
        # follow each attached tmux client back to its terminal window too.
        pid_chains = [parent_pid_chain(os.getpid())]
        pid_chains.extend(parent_pid_chain(pid) for pid in tmux_client_pids())
        for pid_chain in pid_chains:
            if terminal := find_terminal_window(clients, pid_chain):
                return terminal
        return None
    except (json.JSONDecodeError, OSError, subprocess.TimeoutExpired):
        return None


def terminal_window_exists(address: str, pid: int) -> bool:
    if not valid_window_address(address):
        return False
    try:
        process = subprocess.run(
            ["hyprctl", "clients", "-j"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        if process.returncode != 0:
            return False
        clients = json.loads(process.stdout)
    except (json.JSONDecodeError, OSError, subprocess.TimeoutExpired):
        return False
    if not isinstance(clients, list):
        return False
    for client in clients:
        if not isinstance(client, dict) or client.get("address") != address:
            continue
        try:
            return int(client.get("pid")) == pid
        except (TypeError, ValueError):
            return False
    return False


def focus_terminal(address: str, pid: int) -> None:
    if not which("hyprctl") or not terminal_window_exists(address, pid):
        return
    try:
        subprocess.run(
            ["hyprctl", "dispatch", "focuswindow", f"address:{address}"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=1.5,
            check=False,
        )
    except (OSError, subprocess.TimeoutExpired):
        return


def notification_worker() -> int:
    try:
        payload = json.load(sys.stdin)
        title = str(payload["title"])
        body = str(payload["body"])
        urgency = str(payload["urgency"])
        timeout_ms = int(payload["timeout_ms"])
        address = str(payload["address"])
        pid = int(payload["pid"])
    except (KeyError, TypeError, ValueError, json.JSONDecodeError):
        return 2
    if not valid_window_address(address) or not which("notify-send"):
        return 2
    try:
        process = subprocess.run(
            [
                "notify-send",
                "-a",
                "Codex",
                "-i",
                str(ICON),
                "-u",
                urgency,
                "-t",
                str(timeout_ms),
                "--action",
                "default=ターミナルへ移動",
                title,
                body,
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            check=False,
        )
    except OSError:
        return 1
    if process.returncode == 0 and process.stdout.strip() == "default":
        focus_terminal(address, pid)
    return 0


def spawn_actionable_notification(payload: dict[str, object]) -> bool:
    try:
        worker = subprocess.Popen(
            [sys.executable, str(Path(__file__).resolve()), "--notification-worker"],
            stdin=subprocess.PIPE,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
        if worker.stdin is None:
            return False
        worker.stdin.write(json.dumps(payload, ensure_ascii=False).encode())
        worker.stdin.close()
        return True
    except (BrokenPipeError, OSError, TypeError, ValueError):
        return False


def active_hyprland_pid() -> int | None:
    if not os.environ.get("HYPRLAND_INSTANCE_SIGNATURE") or not which("hyprctl"):
        return None
    try:
        p = subprocess.run(
            ["hyprctl", "activewindow", "-j"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=0.8,
            check=False,
        )
        if p.returncode != 0:
            return None
        data = json.loads(p.stdout)
        pid = data.get("pid")
        return int(pid) if pid else None
    except (
        json.JSONDecodeError,
        OSError,
        subprocess.TimeoutExpired,
        TypeError,
        ValueError,
    ):
        return None


def codex_terminal_is_focused() -> bool:
    active_pid = active_hyprland_pid()
    return active_pid is not None and active_pid in parent_pids(os.getpid())


def play_sound(sound_name: str) -> None:
    if not which("canberra-gtk-play"):
        return
    try:
        subprocess.Popen(
            ["canberra-gtk-play", "-i", sound_name, "-d", "Codex"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
    except OSError:
        return


def notify(
    title: str,
    body: str,
    *,
    urgency: str,
    timeout_ms: int,
    sound_name: str,
) -> None:
    if ONLY_WHEN_UNFOCUSED and codex_terminal_is_focused():
        return
    terminal = codex_terminal_window()
    if terminal and which("notify-send"):
        address, pid = terminal
        if spawn_actionable_notification(
            {
                "title": html.escape(title, quote=False),
                "body": html.escape(body, quote=False),
                "urgency": urgency,
                "timeout_ms": timeout_ms,
                "address": address,
                "pid": pid,
            }
        ):
            play_sound(sound_name)
            return
    if which("notify-send"):
        try:
            subprocess.Popen(
                [
                    "notify-send",
                    "-a",
                    "Codex",
                    "-i",
                    str(ICON),
                    "-u",
                    urgency,
                    "-t",
                    str(timeout_ms),
                    html.escape(title, quote=False),
                    html.escape(body, quote=False),
                ],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True,
            )
        except OSError:
            play_sound(sound_name)
            return
    play_sound(sound_name)


def permission_body(event: dict[str, Any]) -> str:
    tool = str(event.get("tool_name") or "Tool")
    tool_input = event.get("tool_input")
    description = ""
    detail = ""
    if isinstance(tool_input, dict):
        description = str(tool_input.get("description") or "")
        if tool in {"Bash", "apply_patch"}:
            detail = str(tool_input.get("command") or "")
        else:
            try:
                detail = json.dumps(
                    tool_input, ensure_ascii=False, separators=(",", ":")
                )
            except (TypeError, ValueError):
                detail = str(tool_input)
    parts = [f"{tool} の承認が必要です"]
    if description:
        parts.append(compact(description, 120))
    if detail:
        parts.append(compact(detail, 180))
    return "\n".join(parts)


def load_event() -> dict[str, Any] | None:
    try:
        if len(sys.argv) > 1:
            event = json.loads(sys.argv[1])
        else:
            event = json.load(sys.stdin)
    except (json.JSONDecodeError, OSError, TypeError):
        return None
    return event if isinstance(event, dict) else None


def main() -> int:
    if len(sys.argv) == 2 and sys.argv[1] == "--notification-worker":
        return notification_worker()
    event = load_event()
    if event is None:
        print(json.dumps({"continue": True}))
        return 0

    hook = str(event.get("hook_event_name") or "")
    project = project_name(event.get("cwd"))

    if event.get("type") == "agent-turn-complete":
        message = (
            compact(event.get("last-assistant-message")) or "タスクが完了しました。"
        )
        notify(
            f"Codex · {project}",
            message,
            urgency="normal",
            timeout_ms=DONE_TIMEOUT,
            sound_name="complete",
        )
        return 0

    if hook == "PermissionRequest":
        notify(
            f"Codex · {project}",
            permission_body(event),
            urgency="critical",
            timeout_ms=APPROVAL_TIMEOUT,
            sound_name="dialog-warning",
        )
        return 0

    if hook == "Stop":
        message = (
            compact(event.get("last_assistant_message")) or "タスクが完了しました。"
        )
        notify(
            f"Codex · {project}",
            message,
            urgency="normal",
            timeout_ms=DONE_TIMEOUT,
            sound_name="complete",
        )
        print(json.dumps({"continue": True}, ensure_ascii=False))
        return 0

    print(json.dumps({"continue": True}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
