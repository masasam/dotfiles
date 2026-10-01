# ThinkPad audio recovery

Install with `make thinkpad-audio` on the X1 Carbon Gen 10.

At boot, this machine sometimes exposes no UCM Speaker profile, leaving the
card off or its Pro Audio speaker switches muted. The user service waits for
PipeWire device discovery, selects Pro Audio only when the card is off or already
using Pro Audio, then enables Speaker and Bass Speaker after profile probing.
It does not modify an active HiFi profile, PipeWire volume, or microphone mute state.
For built-in speakers it sets ALSA Master to 0 dB (100%), so a leftover HiFi
attenuation does not limit the independent Pro Audio software volume. The Master
mute switch is preserved.
Connected external default devices are preserved, and speakers are not enabled
when the headphone jack reports a connected headset.

The service also runs after WirePlumber is restarted. This is a workaround for
the boot-time device/profile initialization problem, not a driver fix.

Inspect: `journalctl --user -u thinkpad-audio-recovery.service -b`

Disable: `systemctl --user disable --now thinkpad-audio-recovery.service`
