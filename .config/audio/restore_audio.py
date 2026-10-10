"""Recover the X1 Carbon Gen 10's missing UCM speaker profile at startup."""

import json
import os
import subprocess
import sys
import time
from pathlib import Path

CARD = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
HIFI = "HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"


def run(*args):
    env = dict(os.environ, LC_ALL="C", LANG="C")
    return subprocess.run(
        args, check=True, capture_output=True, text=True, timeout=5, env=env
    ).stdout


def get_card():
    cards = json.loads(run("pactl", "--format=json", "list", "cards"))
    return next((card for card in cards if card["name"] == CARD), None)


def wait_for(action, timeout=25):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        try:
            result = action()
            if result:
                return result
        except (subprocess.SubprocessError, json.JSONDecodeError):
            pass
        time.sleep(0.5)
    raise RuntimeError("Timed out waiting for the ThinkPad audio device")


def recover():
    card = wait_for(get_card)
    if card["active_profile"].startswith("HiFi"):
        print("HiFi profile active; no recovery needed.")
        return
    if card.get("profiles", {}).get(HIFI, {}).get("available"):
        run("pactl", "set-card-profile", CARD, HIFI)
        print("Selected the available HiFi speaker profile.")
        return
    raise RuntimeError("No available HiFi speaker profile; leaving the card unchanged")


def prepare():
    """Enable the speaker path before WirePlumber probes UCM profiles."""
    jack = wait_for(
        lambda: run(
            "amixer", "-c", "sofhdadsp", "cget", "iface=CARD,name='Headphone Jack'"
        )
    )
    if "values=on" not in jack:
        for control in ("Speaker", "Bass Speaker"):
            run("amixer", "-c", "sofhdadsp", "sset", control, "unmute")


def main():
    if Path("/sys/class/dmi/id/product_version").read_text().strip() != (
        "ThinkPad X1 Carbon Gen 10"
    ):
        return
    if sys.argv[1:] == ["--prepare"]:
        prepare()
    elif not sys.argv[1:]:
        recover()
    else:
        raise ValueError("Expected no arguments or --prepare")


if __name__ == "__main__":
    main()
