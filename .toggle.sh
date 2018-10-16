#!/bin/bash

current_window=$(xdotool getwindowfocus)
browser_window=$(xdotool search --name --onlyvisible "Chromium")
emacs_window=$(xdotool search --name --onlyvisible "Emacs")

if test $current_window -eq $browser_window
then
  xdotool windowactivate $emacs_window
else
  xdotool windowactivate $browser_window
fi
