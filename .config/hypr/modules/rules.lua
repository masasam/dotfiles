return function(context)
    local hl = context.hl

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Scaling a layer while it appears temporarily softens its text on
-- fractional-scale monitors.  Keep the launcher at its final size from the
-- first frame so Fuzzel stays sharp while opening and closing.
hl.layer_rule({
    name = "no-animation-fuzzel",
    match = { namespace = "^fuzzel$" },
    no_anim = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Press the same ALT+number again to return to the previous Workspace
hl.config({
    binds = {
        workspace_back_and_forth = true,
    },
})

hl.window_rule({
    name  = "terminal transparent in the scratchpad",
    match = { workspace = "special:magic" },
	opacity = "0.9 0.1",
    no_blur = true,
})

hl.window_rule({
    name  = "center-pavucontrol",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name  = "center-blueman-manager",
    match = { class = "^(blueman-manager)$" },
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name  = "center-nwg-displays",
    match = { class = "^(nwg-displays)$" },
	float = true,
    center = true,
	size = {1000, 600},
})

hl.window_rule({
    name  = "center-nm-connection-editor",
    match = { class = "^(nm-connection-editor)$" },
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name  = "center-calculator",
    match = { class = "^(org.gnome.Calculator)$" },
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name = "center-pcmanfm-open-file",

    match = {
        class = "^(xdg-desktop-portal-gtk)$",
        title = "^(ファイルを開く)$",
    },

    float = true,
    center = true,
    size = {800, 600},
})

hl.window_rule({
    name  = "center-pcmanfm-open-all-file",
	
	match = {
	    class = "^(xdg-desktop-portal-gtk)$",
		    title = "^(すべてのファイル)$",
	},
	
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name  = "center-baobab",
    match = { class = "^(org.gnome.baobab)$" },
	float = true,
    center = true,
	size = {1280, 800},
})

hl.window_rule({
    name  = "maximize-lximage-qt",
    match = { class = "^(lximage-qt)$" },
	float = true,
    center = true,
	maximize = true,
})

hl.window_rule({
    name  = "fullscreen-mpv",
    match = { class = "^(mpv)$" },
	float = true,
	fullscreen = true,
})

hl.config({
    misc = {
        enable_swallow = true,
        swallow_regex = "^(foot)$",
    },
})

end
