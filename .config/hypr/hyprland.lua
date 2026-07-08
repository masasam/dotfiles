-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.25",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "foot"
local fileManager = "pcmanfm-qt"
local menu        = "pkill fuzzel || fuzzel"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar & hypridle & hyprpaper & hyprsunset")
  hl.exec_cmd("nm-applet --indicator")
  hl.exec_cmd("fcitx5-remote -r & fcitx5 -d --replace")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("systemctl --user start hyprwhspr.service")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("foot", { workspace = "1" })
  hl.exec_cmd("google-chrome-stable", { workspace = "2 silent" })
  hl.exec_cmd("emacs", { workspace = "3 silent" })
  hl.exec_cmd("foot", { workspace = "special:magic silent" })
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("GTK_IM_MODULE", "fcitx")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 3,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "specialWorkspace",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
		special_scale_factor = 0.95,
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "ALT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + V", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })
hl.bind("SUPER + M", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })
hl.bind("SUPER + TAB", hl.dsp.window.cycle_next(), { description = "Focus on next window" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { description = "Focus on previous window" })
hl.bind("CTRL + ALT + TAB", hl.dsp.focus({ monitor = "+1" }), { description = "Focus on next monitor" })
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }), { description = "Focus on previous monitor" })

hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprwhspr record toggle"))

hl.bind(mainMod .. " + CTRL + 0", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-0"))
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-1"))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-2"))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-3"))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-4"))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-5"))
hl.bind(mainMod .. " + CTRL + 6", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-6"))
hl.bind(mainMod .. " + CTRL + 7", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-7"))
hl.bind(mainMod .. " + CTRL + 8", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-8"))
hl.bind(mainMod .. " + CTRL + 9", hl.dsp.exec_cmd("~/.config/hypr/scripts/ctl-alt-9"))

-- Screenshot a window
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window -o 'Pictures/Screenshots'"))
-- Screenshot a monitor
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -o 'Pictures/Screenshots'"))
-- Screenshot a region with satty
hl.bind("SUPER + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/satty"))

-- Move focus with mainMod + arrow keys
hl.bind("SUPER + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + Return", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ workspace = "e+1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.config/hypr/scripts/wp-vol"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.config/hypr/scripts/wp-vol"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/mute --toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/mute --toggle-mic"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+ && ~/.config/hypr/scripts/wp-bright"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%- && ~/.config/hypr/scripts/wp-bright"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- clamshell mode
-- hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/clamshell close"), { locked = true })
-- hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("~/.config/hypr/scripts/clamshell open"), { locked = true })
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ monitor = "l", follow = true }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ monitor = "r", follow = true }))
hl.bind("SUPER + M", hl.dsp.focus({ monitor = "+1" }))

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

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
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
    name  = "center-pcmanfm-open-file",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
	match = { title = "^(ファイルを開く)$" },
	float = true,
    center = true,
	size = {800, 600},
})

hl.window_rule({
    name  = "center-pcmanfm-open-all-file",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
	match = { title = "^(すべてのファイル)$" },
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
    name  = "maximize-vimiv",
    match = { class = "^(vimiv)$" },
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

hl.window_rule({
    name  = "google-chrome",
    match = { class = "^(google-chrome)$" },
	workspace = "2",
})

hl.window_rule({
    name  = "emacs",
    match = { class = "^(Emacs)$" },
	workspace = "3",
})

hl.window_rule({
    name  = "pdf",
    match = { class = "^(org.gnome.Papers)$" },
	workspace = "4",
})

hl.window_rule({
    name  = "beekeeper-studio",
    match = { class = "^(beekeeper-studio)$" },
	workspace = "4",
})

hl.window_rule({
    name  = "sqlitebrowser",
    match = { class = "^(sqlitebrowser)$" },
	workspace = "4",
})

hl.window_rule({
    name  = "libreoffice-writer",
    match = { class = "^(libreoffice-writer)$" },
	workspace = "4",
})

hl.window_rule({
    name  = "libreoffice-calc",
    match = { class = "^(libreoffice-calc)$" },
	workspace = "4",
})

hl.window_rule({
    name  = "pcmanfm",
    match = { class = "^(pcmanfm-qt)$" },
	workspace = "5",
})

hl.window_rule({
    name  = "inkscape",
    match = { class = "^(org.inkscape.Inkscape)$" },
	float = true,
	workspace = "6",
})

hl.window_rule({
    name  = "gimp",
    match = { class = "^(gimp)$" },
	float = true,
	workspace = "6",
})

hl.window_rule({
    name  = "discord",
    match = { class = "^(discord)$" },
	workspace = "7",
})

hl.window_rule({
    name  = "zoom",
    match = { class = "^(zoom)$" },
	workspace = "8",
})

hl.window_rule({
    name  = "Spotify",
    match = { class = "^(Spotify)$" },
	workspace = "9",
})

hl.window_rule({
    name  = "OBS Studio",
    match = { class = "^(com.obsproject.Studio)$" },
	workspace = "9",
})

hl.window_rule({
    name  = "firefox",
    match = { class = "^(firefox)$" },
	workspace = "10",
})
