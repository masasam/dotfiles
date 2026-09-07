-- Hyprland Lua configuration entry point.
-- Feature-specific configuration lives under modules/ and is loaded in the
-- same order as the original monolithic configuration.

local context = {
    hl = hl,
    workspace = {
        terminal = "1",
        web      = "2",
        code     = "3",
        docs     = "4",
        files    = "5",
        docs2    = "6",
        chat     = "7",
        meeting  = "8",
        media    = "9",
        firefox  = "10",
    },
    programs = {
        terminal     = "foot",
        file_manager = "pcmanfm-qt",
        menu         = "pkill fuzzel || fuzzel",
    },
}

-- Monitor rules are applied by the single-output profile in monitors.lua. A
-- catch-all monitor rule here would continuously re-enable its disabled output.
-- Keep lone ultrawide windows from stretching too far horizontally.
hl.config({
    layout = {
        single_window_aspect_ratio = { 16, 10 },
        single_window_aspect_ratio_tolerance = 0.1,
    },
})

require("modules.startup")(context)
require("modules.appearance")(context)
require("modules.input")(context)
require("modules.bindings")(context)
require("modules.monitors")(context)
require("modules.rules")(context)
require("modules.workspaces")(context)
