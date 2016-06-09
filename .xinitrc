export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -drx

tpset() { xinput set-prop "TPPS/2 IBM TrackPoint" "$@"; }

tpset "Evdev Wheel Emulation" 1
tpset "Evdev Wheel Emulation Button" 2
tpset "Evdev Wheel Emulation Timeout" 200
tpset "Evdev Wheel Emulation Axes" 6 7 4 5
tpset "Device Accel Constant Deceleration" 0.95
