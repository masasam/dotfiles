-- Offline smoke and regression checks for the modular Hyprland configuration.

local script = debug.getinfo(1, "S").source:sub(2)
local configDirectory = script:match("^(.*)/[^/]+$") or "."
package.path = configDirectory .. "/?.lua;" .. package.path

local function proxy()
    return setmetatable({}, {
        __index = function()
            return proxy()
        end,
        __call = function()
            return proxy()
        end,
    })
end

local events = {}
local rules = {}
local dispatched = {}
local workspaceWindows = {}
local existingWorkspaces = {}
local openWindows = {}

hl = proxy()
hl.dsp = proxy()
hl.dsp.window = proxy()
hl.dsp.window.move = function(options)
    return { kind = "move", options = options }
end
hl.dispatch = function(action)
    table.insert(dispatched, action)
end
hl.get_monitors = function()
    return {}
end
hl.get_workspace = function(workspace)
    return existingWorkspaces[workspace]
end
hl.get_workspace_windows = function(workspace)
    return workspaceWindows[workspace] or {}
end
hl.get_windows = function()
    return openWindows
end
hl.on = function(event, callback)
    events[event] = callback
end
hl.timer = function()
    return { set_enabled = function() end }
end
hl.window_rule = function(rule)
    rules[rule.name] = rule
    return proxy()
end

local function resetWorkspaceState()
    dispatched = {}
    workspaceWindows = {}
    existingWorkspaces = {}
    openWindows = {}
end

local function expectWorkspace(expected, window)
    events["window.open"](window)
    assert(#dispatched == 1, "expected exactly one workspace move")
    assert(dispatched[1].kind == "move", "expected a window move action")
    assert(dispatched[1].options.workspace == expected,
           string.format("expected workspace %d, got %s",
                         expected, tostring(dispatched[1].options.workspace)))
end

local ok, errorMessage = pcall(dofile, configDirectory .. "/hyprland.lua")
assert(ok, errorMessage)
assert(type(events["window.open"]) == "function", "window.open handler missing")
assert(events["window.class"] == events["window.open"],
       "window.open and window.class must share placement logic")
assert(rules.emacs.match.class == "^(emacs|Emacs)$", "Emacs class rule changed")
assert(rules.pdf.match.class == "^(org.gnome.Papers)$", "PDF class rule changed")

local paper = {
    address = "0xpaper",
    class = "org.gnome.Papers",
    floating = false,
    pid = 100,
    workspace = { id = 1 },
}

-- First pooled application goes to Workspace 4.
resetWorkspaceState()
expectWorkspace(4, paper)

-- The second goes to Workspace 6 when Workspace 4 is occupied.
resetWorkspaceState()
workspaceWindows[4] = {
    { address = "0xexisting-4", class = "org.gnome.Papers", floating = false },
}
expectWorkspace(6, paper)

-- Overflow begins at Workspace 11 when both reserved pool slots are occupied.
resetWorkspaceState()
workspaceWindows[4] = {
    { address = "0xexisting-4", class = "org.gnome.Papers", floating = false },
}
workspaceWindows[6] = {
    { address = "0xexisting-6", class = "libreoffice-writer", floating = false },
}
expectWorkspace(11, paper)

-- Transient floating dialogs from non-graphics pool applications stay put.
resetWorkspaceState()
events["window.open"]({
    address = "0xdialog",
    class = "libreoffice-writer",
    floating = true,
    pid = 200,
    workspace = { id = 4 },
})
assert(#dispatched == 0, "transient document dialog should not move")

-- Additional graphics windows stay beside the same process's main window.
resetWorkspaceState()
openWindows = {
    {
        address = "0xinkscape-main",
        class = "org.inkscape.Inkscape",
        floating = true,
        pid = 300,
        workspace = { id = 12 },
    },
}
expectWorkspace(12, {
    address = "0xinkscape-second",
    class = "org.inkscape.Inkscape",
    floating = true,
    pid = 300,
    workspace = { id = 4 },
})

print("Hyprland configuration checks passed")
