# deskctl

Small Zig controller for Hyprland media-key actions. It replaces the former
Python volume and brightness helpers while continuing to use `wpctl`,
`brightnessctl`, and `notify-send` as the system interfaces.

Build the release binary from the dotfiles root:

```console
make deskctl
```

Supported commands:

```text
deskctl volume up|down|mute
deskctl microphone mute
deskctl brightness up|down
```

Run the parser tests with:

```console
zig build --build-file .config/hypr/deskctl/build.zig test
```
