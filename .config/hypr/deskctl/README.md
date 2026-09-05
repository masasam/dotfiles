# deskctl

Small Zig controller for Hyprland media-key and screenshot actions. It replaces
the former Python volume and brightness helpers and the former Bash screenshot
helper while continuing to use the standard desktop command-line interfaces.

Build the release binary from the dotfiles root:

```console
make deskctl
```

Supported commands:

```text
deskctl volume up|down|mute
deskctl microphone mute
deskctl brightness up|down
deskctl screenshot region|window|output
```

Run the parser tests with:

```console
zig build --build-file .config/hypr/deskctl/build.zig test
```
