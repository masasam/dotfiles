"""Recover the X1 Carbon Gen 10's missing UCM speaker profile at startup."""

import json
import os
import subprocess
import time
from pathlib import Path

CARD = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
SINK = CARD.replace("alsa_card.", "alsa_output.") + ".pro-output-0"
SOURCE = CARD.replace("alsa_card.", "alsa_input.") + ".pro-input-6"


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
    if card["active_profile"] not in ("off", "pro-audio"):
        print("HiFi profile active; no recovery needed.")
        return
    run("pactl", "set-card-profile", CARD, "pro-audio")
    wait_for(lambda: SINK in run("pactl", "list", "short", "sinks"))
    wait_for(lambda: SOURCE in run("pactl", "list", "short", "sources"))
    # Profile probing can reset ALSA switches after the nodes first appear.
    time.sleep(2)
    if get_card()["active_profile"] != "pro-audio":
        return
    jack = run("amixer", "-c", "sofhdadsp", "cget", "iface=CARD,name='Headphone Jack'")
    if "values=on" not in jack:
        for control in ("Speaker", "Bass Speaker"):
            run("amixer", "-c", "sofhdadsp", "sset", control, "unmute")
        # Pro Audio uses software volume; a leftover HiFi Master attenuation
        # otherwise limits speaker output even when PipeWire shows 100%.
        # Preserve the Master mute switch and the user's PipeWire volume.
        run("amixer", "-c", "sofhdadsp", "sset", "Master", "100%")
    # Keep a connected external output/input selected; fix stale local defaults.
    for kind, node in (("sink", SINK), ("source", SOURCE)):
        current = run("pactl", f"get-default-{kind}").strip()
        # Do not replace the saved output preference when Bluetooth is absent:
        # WirePlumber uses the local fallback and restores it on reconnection.
        if current == "auto_null" or (
            kind == "source" and "pci-0000_00_1f.3" in current
        ):
            run("pactl", f"set-default-{kind}", node)
    print("Recovered ThinkPad Pro Audio speakers and digital microphone.")


def main():
    if Path("/sys/class/dmi/id/product_version").read_text().strip() != (
        "ThinkPad X1 Carbon Gen 10"
    ):
        return
    recover()


if __name__ == "__main__":
    main()
