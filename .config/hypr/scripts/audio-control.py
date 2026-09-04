#!/usr/bin/env python3
"""Control WirePlumber volume and mute state with desktop feedback."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

ICON_DIRECTORY = Path.home() / ".config/mako/icons"
OUTPUT = "@DEFAULT_AUDIO_SINK@"
INPUT = "@DEFAULT_AUDIO_SOURCE@"


class AudioControlError(RuntimeError):
    """Raised when an audio command fails or returns unexpected output."""


def run(*arguments: str) -> str:
    """Run ARGUMENTS and return standard output."""
    try:
        result = subprocess.run(
            arguments,
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as error:
        raise AudioControlError(f"{arguments[0]} is not installed") from error
    except subprocess.CalledProcessError as error:
        detail = (error.stderr or error.stdout or "unknown error").strip()
        raise AudioControlError(f"{' '.join(arguments)} failed: {detail}") from error
    return result.stdout


def get_volume(target: str) -> tuple[int, bool]:
    """Return TARGET's volume percentage and mute state."""
    output = run("wpctl", "get-volume", target).strip()
    match = re.fullmatch(r"Volume:\s+([0-9]+(?:\.[0-9]+)?)(\s+\[MUTED\])?", output)
    if match is None:
        raise AudioControlError(f"unexpected wpctl output: {output!r}")
    percentage = min(100, max(0, round(float(match.group(1)) * 100)))
    return percentage, match.group(2) is not None


def notify(summary: str, icon: str, percentage: int, notification_id: str) -> None:
    """Show an audio notification without failing the completed action."""
    try:
        subprocess.run(
            [
                "notify-send",
                "-i",
                str(ICON_DIRECTORY / icon),
                "-t",
                "1000",
                "-a",
                "wp-vol",
                "-h",
                f"string:x-canonical-private-synchronous:{notification_id}",
                "-h",
                f"int:value:{percentage}",
                summary,
            ],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except FileNotFoundError:
        pass


def change_volume(delta: str) -> None:
    """Adjust output volume by DELTA and show its resulting value."""
    run("wpctl", "set-volume", "-l", "1", OUTPUT, delta)
    percentage, muted = get_volume(OUTPUT)
    icon = "audio-volume-muted.png" if muted else "audio-volume-high.png"
    suffix = " (muted)" if muted else ""
    notify(f"Volume: {percentage}%{suffix}", icon, percentage, "volume")


def toggle_mute(target: str, *, microphone: bool) -> None:
    """Toggle TARGET's mute state and show its resulting state."""
    run("wpctl", "set-mute", target, "toggle")
    percentage, muted = get_volume(target)
    if microphone:
        icon = (
            "microphone-sensitivity-muted.png"
            if muted
            else "microphone-sensitivity-high.png"
        )
        summary = "Microphone muted" if muted else "Microphone unmuted"
        notification_id = "microphone"
    else:
        icon = "audio-volume-muted.png" if muted else "audio-volume-high.png"
        summary = "Volume muted" if muted else "Volume unmuted"
        notification_id = "volume"
    notify(summary, icon, percentage, notification_id)


def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "action",
        choices=("volume-up", "volume-down", "mute-output", "mute-input"),
    )
    return parser.parse_args()


def main() -> int:
    """Run the requested audio action."""
    action = parse_arguments().action
    try:
        if action == "volume-up":
            change_volume("5%+")
        elif action == "volume-down":
            change_volume("5%-")
        elif action == "mute-output":
            toggle_mute(OUTPUT, microphone=False)
        else:
            toggle_mute(INPUT, microphone=True)
    except AudioControlError as error:
        print(f"audio-control: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
