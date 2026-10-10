"""Start hyprwhspr on demand and stop it after two minutes of inactivity."""

import fcntl
import os
import stat
import subprocess
import sys
import time
from pathlib import Path

SERVICE = "hyprwhspr.service"
WATCHER = "hyprwhspr-idle.service"
RUNTIME = Path(os.environ.get("XDG_RUNTIME_DIR", f"/tmp/hyprwhspr-{os.getuid()}"))
STATE = RUNTIME / "hyprwhspr"
ACTIVITY = STATE / "ondemand-activity"


def systemctl(*args):
    subprocess.run(["systemctl", "--user", *args], check=True, timeout=30)


def read_state(name):
    try:
        return (STATE / name).read_text().strip().lower()
    except FileNotFoundError:
        return ""


def busy():
    return read_state("recording_status") == "true" or read_state(
        "visualizer_state"
    ) in {"recording", "paused", "processing"}


def ready():
    fifo = STATE / "recording_control"
    try:
        if not stat.S_ISFIFO(fifo.stat().st_mode):
            return False
        fd = os.open(fifo, os.O_WRONLY | os.O_NONBLOCK)
        os.close(fd)
        return True
    except OSError:
        return False


def watch():
    last_busy = time.monotonic()
    while True:
        time.sleep(5)
        with (STATE / "ondemand.lock").open("a") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            active = subprocess.run(
                ["systemctl", "--user", "is-active", "--quiet", SERVICE],
                check=False,
                timeout=5,
            )
            if active.returncode:
                return
            if busy():
                last_busy = time.monotonic()
                continue
            if time.monotonic() - last_busy < 120:
                continue
            if time.time() - ACTIVITY.stat().st_mtime < 120:
                continue
            systemctl("stop", SERVICE)
            return


def main():
    STATE.mkdir(mode=0o700, parents=True, exist_ok=True)
    action = sys.argv[1] if len(sys.argv) == 2 else ""
    if action == "watch":
        watch()
        return
    if action not in {"start", "toggle", "restart"}:
        raise ValueError("Expected start, toggle, restart, or watch")
    with (STATE / "ondemand.lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        ACTIVITY.touch()
        systemctl("restart" if action == "restart" else "start", SERVICE)
        deadline = time.monotonic() + 90
        while not ready():
            if time.monotonic() >= deadline:
                systemctl("stop", SERVICE)
                raise RuntimeError("hyprwhspr startup timed out")
            time.sleep(0.2)
        systemctl("start", WATCHER)
        ACTIVITY.touch()
        if action == "toggle":
            subprocess.run(["hyprwhspr", "record", "toggle"], check=True, timeout=10)


if __name__ == "__main__":
    main()
