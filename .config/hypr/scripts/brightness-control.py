#!/usr/bin/env python3
"""Control display brightness with desktop feedback."""

from __future__ import annotations

import argparse
import csv
import subprocess
import sys
from pathlib import Path

ICON = Path.home() / ".config/mako/icons/computer.png"


class BrightnessControlError(RuntimeError):
    """Raised when brightnessctl fails or returns unexpected output."""


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
        raise BrightnessControlError(f"{arguments[0]} is not installed") from error
    except subprocess.CalledProcessError as error:
        detail = (error.stderr or error.stdout or "unknown error").strip()
        raise BrightnessControlError(
            f"{' '.join(arguments)} failed: {detail}"
        ) from error
    return result.stdout


def get_brightness() -> int:
    """Return the current backlight percentage."""
    output = run("brightnessctl", "-m", "-c", "backlight").strip()
    try:
        first_line = next(line for line in output.splitlines() if line)
        row = next(csv.reader([first_line]))
        percentage = row[3]
        if not percentage.endswith("%"):
            raise ValueError("percentage field has no percent sign")
        return min(100, max(0, int(percentage[:-1])))
    except (csv.Error, IndexError, StopIteration, ValueError) as error:
        raise BrightnessControlError(
            f"unexpected brightnessctl output: {output!r}"
        ) from error


def notify(percentage: int) -> None:
    """Show the current brightness without failing the completed action."""
    try:
        subprocess.run(
            [
                "notify-send",
                "-i",
                str(ICON),
                "-t",
                "1000",
                "-a",
                "wp-bright",
                "-h",
                "string:x-canonical-private-synchronous:bright",
                "-h",
                f"int:value:{percentage}",
                f"Brightness: {percentage}%",
            ],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except FileNotFoundError:
        pass


def parse_arguments() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("up", "down"))
    return parser.parse_args()


def main() -> int:
    """Apply the requested brightness action."""
    action = parse_arguments().action
    delta = "5%+" if action == "up" else "5%-"
    try:
        run(
            "brightnessctl",
            "-e4",
            "-n2",
            "-c",
            "backlight",
            "set",
            delta,
        )
        notify(get_brightness())
    except BrightnessControlError as error:
        print(f"brightness-control: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
