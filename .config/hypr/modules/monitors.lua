return function(context)
    local hl = context.hl
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

end

