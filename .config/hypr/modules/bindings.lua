return function(context)
    local hl = context.hl
    local programs = context.programs
    local terminal = programs.terminal
    local fileManager = programs.file_manager
    local menu = programs.menu

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

for workspace = 0, 9 do
    hl.bind(
        mainMod .. " + CTRL + " .. workspace,
        hl.dsp.exec_cmd("~/.config/hypr/workspace-toggle/target/release/ctl-alt-workspace " .. workspace)
    )
end

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
hl.bind("SUPER + Print", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl screenshot region"))

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
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl volume up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl volume mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl microphone mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl brightness up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/deskctl/zig-out/bin/deskctl brightness down"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

end

