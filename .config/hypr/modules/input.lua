return function(context)
    local hl = context.hl
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

end

