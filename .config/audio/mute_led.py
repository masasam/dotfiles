"""Synchronize the ThinkPad mute LED with the current PipeWire output."""

import os
import selectors
import subprocess
from pathlib import Path

LED = Path("/sys/class/leds/platform::mute/brightness")


def sync_led():
    result = subprocess.run(
        ["pactl", "get-sink-mute", "@DEFAULT_SINK@"],
        capture_output=True,
        text=True,
        timeout=3,
        env=dict(os.environ, LC_ALL="C", LANG="C"),
        check=True,
    )
    state = result.stdout.strip()
    if state not in ("Mute: yes", "Mute: no"):
        raise RuntimeError("Unexpected pactl mute response")
    brightness = "1" if state == "Mute: yes" else "0"
    if LED.read_text().strip() != brightness:
        subprocess.run(
            ["brightnessctl", "-q", "-d", "platform::mute", "set", brightness],
            check=True,
            timeout=3,
        )


def main():
    if not LED.exists():
        return
    # Events cover mute changes and output switching. A periodic check also
    # corrects LED changes made independently by the kernel's audio-mute trigger.
    with subprocess.Popen(["pactl", "subscribe"], stdout=subprocess.PIPE) as events:
        try:
            with selectors.DefaultSelector() as selector:
                selector.register(events.stdout, selectors.EVENT_READ)
                sync_led()
                while True:
                    if not selector.select(timeout=2):
                        sync_led()
                        continue
                    data = os.read(events.stdout.fileno(), 65536)
                    if not data:
                        raise RuntimeError("PipeWire event subscription closed")
                    # Ignore client events caused by our own pactl queries.
                    if b" on sink " in data or b" on server " in data:
                        sync_led()
        finally:
            events.terminate()


if __name__ == "__main__":
    main()
