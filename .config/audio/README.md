# ThinkPad audio recovery

Install with `make thinkpad-audio` on the X1 Carbon Gen 10.

`thinkpad-audio-prepare.service` enables the speaker path before WirePlumber's
UCM discovery. The recovery step prefers an available HiFi Speaker profile;
Pro Audio fallback is disabled: if HiFi discovery fails, the service reports
an error and leaves the card unchanged. Both steps are oneshot, not continuously
running monitors. The preparation order has been verified after a full reboot.
Neither step sets the default output when
HiFi is selected, preserving the saved Bluetooth output preference.

At boot, this machine sometimes exposes no UCM Speaker profile, leaving the
card off. The preparation service enables Speaker and Bass Speaker before
WirePlumber starts. The recovery service waits for PipeWire device discovery
and selects the HiFi speaker profile if no HiFi profile is already active.
It does not modify an active HiFi profile, PipeWire volume, or microphone mute state.
ALSA Master volume and mute switches are left unchanged.
Connected external default devices are preserved, and speakers are not enabled
when the headphone jack reports a connected headset.

The service also runs after WirePlumber is restarted. This is a workaround for
the boot-time device/profile initialization problem, not a driver fix.

Inspect: `journalctl --user -u thinkpad-audio-recovery.service -b`

Disable: `systemctl --user disable --now thinkpad-audio-recovery.service`

## Mute key LED

The internal speaker mute LED uses the kernel's standard `audio-mute` trigger.
No LED monitoring service is required. AfterShokz mute does not control this LED.
