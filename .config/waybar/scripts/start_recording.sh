#!/bin/bash
pkill wl-screenrec || wl-screenrec -f "$(xdg-user-dir VIDEOS)/$(date +'%Y-%m-%d-%H%M%S.mp4')"
