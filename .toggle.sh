#!/bin/bash

current_window=$(xdotool getwindowfocus)
emacs_window=$(xdotool search --name --onlyvisible "Emacs")
browser_window=$(xdotool search --name --onlyvisible "Chromium")

if test $current_window -eq $emacs_window
then
  xdotool windowactivate $browser_window
else
  xdotool windowactivate $emacs_window
fi
