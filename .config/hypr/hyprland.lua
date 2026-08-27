-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

local WORKSPACE = {
    terminal = "1",
    web      = "2",
    code     = "3",
    docs     = "4",
    files    = "5",
    graphics = "6",
    chat     = "7",
    meeting  = "8",
    media    = "9",
    firefox  = "10",
}

------------------
---- MONITORS ----
------------------

-- Monitor rules are applied by the single-output profile below.  A catch-all
-- rule here would continuously re-enable the output that profile disables.

-- When there is only one window at 3840 x 1600, prevent it from stretching too much horizontally
hl.config({
    layout = {
        single_window_aspect_ratio = { 16, 10 },
        single_window_aspect_ratio_tolerance = 0.1,
    },
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
  hl.exec_cmd("snappy-switcher --daemon")
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("systemctl --user start hyprwhspr.service")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("foot", { workspace = WORKSPACE.terminal })
  hl.exec_cmd("google-chrome-stable", { workspace = WORKSPACE.web .. " silent" })
  hl.exec_cmd("emacs", { workspace = WORKSPACE.code .. " silent" })
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")


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
        gaps_in  = 5,
        gaps_out = 5,

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

-- Setting to erase gaps, borders, and rounding only when there is only one window in Workspace
hl.workspace_rule({
    workspace = "w[tv1]s[false]",
    gaps_out = 3,
    gaps_in = 3,
})

hl.window_rule({
    name = "single-window-no-border",

    match = {
        float = false,
        workspace = "w[tv1]s[false]",
    },

    border_size = 2,
    rounding = 10,
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
    fingers = 2,
    direction = "pinch",
    action = "cursorZoom",
    zoom_level = 1,
    mode = "live",
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Hide the mouse cursor while using the keyboard
hl.config({
    cursor = {
        hide_on_key_press = true,
        inactive_timeout = 5,
    },
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

-- Click-drag and long-drag
hl.config({
    binds = {
        drag_threshold = 10,
    },
})

hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true,
        drag = true,
    }
)

hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.float(),
    {
        mouse = true,
        click = true,
    }
)

hl.bind(
  "SUPER + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true }
)

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

-- Automatically hide scratchpad when changing Workspace
hl.config({
    binds = {
        hide_special_on_workspace_change = true,
    },
})

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + Return", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod alt"))
-- hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ workspace = "e+1" }))

-- Swap left and right windows
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))

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

-------------------------------------------------------------------------
---- Use only the laptop or external monitor as your primary monitor ----
-------------------------------------------------------------------------

hl.config({
    debug = {
        disable_scale_checks = true,
    },
})

local laptop = "eDP-1"
local external = "DP-3"

local laptopScale = 1.25
local externalScale = 1.3973799126637554

local function externalActive()
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name == external then
            return true
        end
    end

    return false
end

-- hl.get_monitors() only returns active outputs.  During startup DP-3 may not
-- be active yet, so check the DRM connector state before choosing a profile.
local function externalConnected()
    local pipe = io.popen("grep -l ^connected$ /sys/class/drm/card*-DP-3/status 2>/dev/null")

    if not pipe then
        return externalActive()
    end

    local connectedPath = pipe:read("*l")
    pipe:close()

    return connectedPath ~= nil
end

-- hl.monitor() itself emits monitor.added/removed events.  Remember the
-- selected profile so those events do not recursively apply the same setup.
local activeMonitorProfile = nil

local function useExternal()
    if activeMonitorProfile == "external" then
        return
    end

    activeMonitorProfile = "external"

    hl.monitor({
        output = external,
        disabled = false,
        mode = "preferred",
        position = "0x0",
        scale = externalScale,
    })

    hl.monitor({
        output = laptop,
        disabled = true,
    })
end

local function useLaptop()
    if activeMonitorProfile == "laptop" then
        return
    end

    activeMonitorProfile = "laptop"

    hl.monitor({
        output = laptop,
        disabled = false,
        mode = "preferred",
        position = "0x0",
        scale = laptopScale,
    })

    hl.monitor({
        output = external,
        disabled = true,
    })
end

-- Register the selected rules while the config is being evaluated.  Runtime
-- hl.monitor() calls are temporary and are reset by a config reload.
if externalConnected() then
    useExternal()
else
    useLaptop()
end

-- Manual switching
hl.bind(
    "CTRL + ALT + SUPER + N",
    useExternal
)

hl.bind(
    "CTRL + ALT + SUPER + SHIFT + N",
    useLaptop
)

-- Hotplug events can arrive before the DRM state has settled.  Debounce them.
local pendingMonitorProfile = nil

local reconcileTimer = hl.timer(function()
    local profile = pendingMonitorProfile
    pendingMonitorProfile = nil

    if profile == "external" then
        useExternal()
    elseif profile == "laptop" then
        useLaptop()
    end
end, { timeout = 500, type = "oneshot" })

reconcileTimer:set_enabled(false)

local function scheduleMonitorReconcile(profile)
    pendingMonitorProfile = profile
    reconcileTimer:set_enabled(false)
    reconcileTimer:set_enabled(true)
end

hl.on("monitor.added", function(monitor)
    if monitor.name == external then
        scheduleMonitorReconcile("external")
    end
end)

hl.on("monitor.removed", function(monitor)
    -- useLaptop() disables DP-3 itself; do not treat that as a physical unplug.
    if monitor.name == external and activeMonitorProfile ~= "laptop" then
        scheduleMonitorReconcile("laptop")
    end
end)

-- Also reconcile after every config load; hyprland.start is not emitted on a
-- reload.  The physical DRM state is already available at this point.
scheduleMonitorReconcile(externalConnected() and "external" or "laptop")

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

hl.config({
    misc = {
        enable_swallow = true,
        swallow_regex = "^(foot)$",
    },
})

hl.workspace_rule({
    workspace = "4",
    layout = "scrolling",
})

hl.bind(
    "SUPER + comma",
    hl.dsp.layout("move -col")
)

hl.bind(
    "SUPER + period",
    hl.dsp.layout("move +col")
)

hl.bind(
    "SUPER + SHIFT + comma",
    hl.dsp.layout("swapcol l")
)

hl.bind(
    "SUPER + SHIFT + period",
    hl.dsp.layout("swapcol r")
)

-- Opening specialscratchpad launches foot
hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "foot",
})

local workspaceApps = {
    -- Workspace 2: Browser
    { name = "google-chrome",      class = "^(google-chrome)$",          workspace = WORKSPACE.web },

    -- Workspace 3: Editor
    { name = "emacs",              class = "^(Emacs)$",                  workspace = WORKSPACE.code },

    -- Workspace 4: Documents / DB
    { name = "pdf",                class = "^(org.gnome.Papers)$",       workspace = WORKSPACE.docs },
    { name = "beekeeper-studio",   class = "^(beekeeper-studio)$",      workspace = WORKSPACE.docs },
    { name = "sqlitebrowser",      class = "^(sqlitebrowser)$",          workspace = WORKSPACE.docs },
    { name = "libreoffice-writer", class = "^(libreoffice-writer)$",     workspace = WORKSPACE.docs },
    { name = "libreoffice-calc",   class = "^(libreoffice-calc)$",       workspace = WORKSPACE.docs },

    -- Workspace 5: Files
    { name = "pcmanfm",            class = "^(pcmanfm-qt)$",             workspace = WORKSPACE.files },

    -- Workspace 6: Graphics
    { name = "inkscape",           class = "^(org.inkscape.Inkscape)$", workspace = WORKSPACE.graphics, float = true },
    { name = "gimp",               class = "^(gimp)$",                   workspace = WORKSPACE.graphics, float = true },

    -- Workspace 7: Chat
    { name = "discord",            class = "^(discord)$",                workspace = WORKSPACE.chat },

    -- Workspace 8: Meeting
    { name = "zoom",               class = "^(zoom)$",                   workspace = WORKSPACE.meeting },

    -- Workspace 9: Media
    { name = "spotify",            class = "^(Spotify)$",                workspace = WORKSPACE.media },
    { name = "obs",                class = "^(com.obsproject.Studio)$", workspace = WORKSPACE.media },

    -- Workspace 10: Secondary browser
    { name = "firefox",            class = "^(firefox)$",                workspace = WORKSPACE.firefox },
}

for _, app in ipairs(workspaceApps) do
    hl.window_rule({
        name = app.name,
        match = {
            class = app.class,
        },
        workspace = app.workspace,
        float = app.float,
    })
end
