# ctl-alt-workspace

Rust helper for the `mainMod + Ctrl + 0..9` Hyprland bindings. It temporarily
moves the sole window from the selected workspace beside the current window;
pressing the same binding again restores it.

Build and test from the dotfiles root:

```console
make workspace-toggle
cargo test --manifest-path .config/hypr/workspace-toggle/Cargo.toml
```

Workspace `0` maps to `special:magic`.
