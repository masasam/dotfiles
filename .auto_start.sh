#!/bin/bash
# Script to apply .Xresources at GUI startup
# See ${PWD}/.config/autostart/autostart.desktop
sleep 1
xrdb -merge $HOME/.Xresources
xdotool key shift+space
exit
