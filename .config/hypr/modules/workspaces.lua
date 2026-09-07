return function(context)
    local hl = context.hl
    local WORKSPACE = context.workspace

-- Opening specialscratchpad launches foot
hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "foot",
})

local workspaceApps = {
    -- Workspace 2: Browser
    { name = "google-chrome",      class = "google-chrome",          workspace = WORKSPACE.web },

    -- Workspace 3: Editor
    { name = "emacs",              class = "emacs", class_pattern = "^(emacs|Emacs)$", workspace = WORKSPACE.code },

    -- Workspace pool 4 -> 6 -> 11...: Documents / DB / Graphics
    { name = "pdf",                class = "org.gnome.Papers",       workspace = WORKSPACE.docs, pool = true },
    { name = "beekeeper-studio",   class = "beekeeper-studio",      workspace = WORKSPACE.docs, pool = true },
    { name = "sqlitebrowser",      class = "sqlitebrowser",          workspace = WORKSPACE.docs, pool = true },
    { name = "libreoffice-writer", class = "libreoffice-writer",     workspace = WORKSPACE.docs, pool = true },
    { name = "libreoffice-calc",   class = "libreoffice-calc",       workspace = WORKSPACE.docs, pool = true },
    { name = "inkscape",           class = "org.inkscape.Inkscape", workspace = WORKSPACE.docs, pool = true, float = true },
    { name = "gimp",               class = "gimp",                   workspace = WORKSPACE.docs, pool = true, float = true },

    -- Workspace 5: Files
    { name = "pcmanfm",            class = "pcmanfm-qt",             workspace = WORKSPACE.files },

    -- Workspace 7: Chat
    { name = "discord",            class = "discord",                workspace = WORKSPACE.chat },

    -- Workspace 8: Meeting
    { name = "zoom",               class = "zoom",                   workspace = WORKSPACE.meeting },

    -- Workspace 9: Media
    { name = "spotify",            class = "Spotify",                workspace = WORKSPACE.media },
    { name = "obs",                class = "com.obsproject.Studio", workspace = WORKSPACE.media },

    -- Workspace 10: Secondary browser
    { name = "firefox",            class = "firefox",                workspace = WORKSPACE.firefox },
}

-- Derive pool membership from the app definitions so the two lists cannot
-- drift apart when applications are added or removed.
local workspacePoolAppClasses = {}
local workspacePoolFloatingClasses = {}

for _, app in ipairs(workspaceApps) do
    if app.pool then
        workspacePoolAppClasses[app.class] = true
        if app.float then
            workspacePoolFloatingClasses[app.class] = true
        end
    end

    hl.window_rule({
        name = app.name,
        match = {
            class = app.class_pattern or "^(" .. app.class .. ")$",
        },
        workspace = app.workspace,
        float = app.float,
    })
end

-- Place Documents / DB / Graphics apps on Workspaces 4, 6, then unused numeric
-- workspaces starting at 11.  Workspaces 5 and 7-10 remain reserved above.
local workspacePoolSlots = {
    tonumber(WORKSPACE.docs),
    tonumber(WORKSPACE.docs2),
}

local function nextWorkspacePoolOverflow()
    local workspace = 11

    while hl.get_workspace(workspace) ~= nil do
        workspace = workspace + 1
    end

    return workspace
end

local function workspacePoolSlotOccupied(workspace, openingWindow)
    for _, candidate in ipairs(hl.get_workspace_windows(workspace)) do
        if candidate.address ~= openingWindow.address
            and workspacePoolAppClasses[candidate.class]
            and (not candidate.floating or workspacePoolFloatingClasses[candidate.class]) then
            return true
        end
    end

    return false
end

local function placeWorkspacePoolApp(window)
    if window == nil or not workspacePoolAppClasses[window.class] then
        return
    end

    -- Ignore transient floating dialogs from the non-graphics applications.
    if window.floating and not workspacePoolFloatingClasses[window.class] then
        return
    end

    local currentWorkspace = window.workspace

    -- Workspaces 11 and above are the overflow area managed by this function.
    -- Do not move a window again when a later class event is received.
    if currentWorkspace ~= nil and currentWorkspace.id >= 11 then
        return
    end

    -- Keep additional windows belonging to the same floating graphics process
    -- beside its main window instead of consuming another workspace slot.
    if workspacePoolFloatingClasses[window.class] then
        for _, candidate in ipairs(hl.get_windows()) do
            if candidate.address ~= window.address
                and candidate.pid == window.pid
                and candidate.class == window.class
                and candidate.workspace ~= nil then
                if currentWorkspace == nil or currentWorkspace.id ~= candidate.workspace.id then
                    hl.dispatch(hl.dsp.window.move({
                        workspace = candidate.workspace.id,
                        follow = false,
                        window = window,
                    }))
                end
                return
            end
        end
    end

    local targetWorkspace = nil
    for _, workspace in ipairs(workspacePoolSlots) do
        if not workspacePoolSlotOccupied(workspace, window) then
            targetWorkspace = workspace
            break
        end
    end

    targetWorkspace = targetWorkspace or nextWorkspacePoolOverflow()

    if currentWorkspace ~= nil and currentWorkspace.id == targetWorkspace then
        return
    end

    hl.dispatch(hl.dsp.window.move({
        workspace = targetWorkspace,
        follow = false,
        window = window,
    }))
end

-- window.open handles normal launches after static rules have run.  Some apps,
-- notably LibreOffice, can finalize their class after mapping, so class changes
-- must run through the same placement logic as well.
hl.on("window.open", placeWorkspacePoolApp)
hl.on("window.class", placeWorkspacePoolApp)
end
