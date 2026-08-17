#!/usr/bin/env python3
from __future__ import annotations

import html
import json
import os
from pathlib import Path
import subprocess
import sys
from typing import Any


def env_int(name: str, default: int) -> int:
    try:
        return int(os.environ.get(name, str(default)))
    except ValueError:
        return default


MAX_CHARS = max(80, env_int("CODEX_NOTIFY_MAX_CHARS", 240))
DONE_TIMEOUT = max(1000, env_int("CODEX_NOTIFY_TIMEOUT_MS", 7000))
APPROVAL_TIMEOUT = max(1000, env_int("CODEX_NOTIFY_APPROVAL_TIMEOUT_MS", 12000))
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
        if p.returncode == 0 and root:
            return Path(root).name
    except Exception:
        pass
    try:
        return Path(cwd).resolve().name or "Codex"
    except Exception:
        return "Codex"


def which(name: str) -> str | None:
    for directory in os.environ.get("PATH", "").split(os.pathsep):
        candidate = Path(directory) / name
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return str(candidate)
    return None


def parent_pids(pid: int) -> set[int]:
    result: set[int] = set()
    current = pid
    for _ in range(64):
        if current <= 1 or current in result:
            break
        result.add(current)
        try:
            stat = Path(f"/proc/{current}/stat").read_text()
            after_comm = stat.rsplit(")", 1)[1].strip().split()
            current = int(after_comm[1])
        except Exception:
            break
    if current > 0:
        result.add(current)
    return result


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
    except Exception:
        return None


def codex_terminal_is_focused() -> bool:
    active_pid = active_hyprland_pid()
    return active_pid is not None and active_pid in parent_pids(os.getpid())


def notify(title: str, body: str, *, urgency: str, timeout_ms: int) -> None:
    if ONLY_WHEN_UNFOCUSED and codex_terminal_is_focused():
        return
    if not which("notify-send"):
        return
    try:
        subprocess.run(
            [
                "notify-send",
                "-a", "Codex",
                "-i", "utilities-terminal-symbolic",
                "-u", urgency,
                "-t", str(timeout_ms),
                html.escape(title, quote=False),
                html.escape(body, quote=False),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=2,
            check=False,
        )
    except Exception:
        pass


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
                detail = json.dumps(tool_input, ensure_ascii=False, separators=(",", ":"))
            except Exception:
                detail = str(tool_input)
    parts = [f"{tool} の承認が必要です"]
    if description:
        parts.append(compact(description, 120))
    if detail:
        parts.append(compact(detail, 180))
    return "\n".join(parts)


def main() -> int:
    try:
        event = json.load(sys.stdin)
    except Exception:
        print(json.dumps({"continue": True}))
        return 0

    hook = str(event.get("hook_event_name") or "")
    project = project_name(event.get("cwd"))

    if hook == "PermissionRequest":
        notify(
            f"Codex · {project}",
            permission_body(event),
            urgency="critical",
            timeout_ms=APPROVAL_TIMEOUT,
        )
        return 0

    if hook == "Stop":
        message = compact(event.get("last_assistant_message")) or "タスクが完了しました。"
        notify(
            f"Codex · {project}",
            message,
            urgency="normal",
            timeout_ms=DONE_TIMEOUT,
        )
        print(json.dumps({"continue": True}, ensure_ascii=False))
        return 0

    print(json.dumps({"continue": True}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
