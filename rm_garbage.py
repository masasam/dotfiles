#!/usr/bin/env python
"""Remove the garbage file."""

import os
import shutil


garbagefiles = [
    '~/.recently-used',
    '~/.local/share/recently-used.xbel',
    '~/.thumbnails',
    '~/.gconfd',
    '~/.gconf',
    '~/.local/share/gegl-0.2',
    '~/.gstreamer-0.10',
    '~/.pulse',
    '~/.esd_auth',
    '~/.config/enchant',
    '~/.spicec',
    '~/.dropbox-dist',
    '~/.parallel',
    '~/.dbus',
    '~/.distlib/',
    '~/.bazaar/',
    '~/.bzr.log',
    '~/.nv/',
    '~/.viminfo',
    '~/.npm/',
    '~/.java/',
    '~/.oracle_jre_usage/',
    '~/.jssc/',
    '~/.tox/',
    '~/.pylint.d/',
    '~/.qute_test/',
    '~/.QtWebEngineProcess/',
    '~/.qutebrowser/',
    '~/.asy/',
    '~/.cmake/',
    '~/.gnome/',
    '~/.texlive/',
    '~/.w3m/',
]


def yes_or_no(question, default="n"):
    """Asks user for yes or no."""
    prompt = "%s (y/[n]) " % question

    answer = input(prompt).strip().lower()

    if not answer:
        answer = default

    if answer == "y":
        return True
    return False


def rm_garbage():
    print("Found garbage files:")
    found = []
    for f in garbagefiles:
        expandfile = os.path.expanduser(f)
        if os.path.exists(expandfile):
            found.append(expandfile)
            print("    %s" % f)

    if len(found) == 0:
        print("No garbage files found :)")
        return

    if yes_or_no("Remove all?", default="n"):
        for f in found:
            if os.path.isfile(f):
                os.remove(f)
            else:
                shutil.rmtree(f)
        print("All cleaned")
    else:
        print("No file removed")


if __name__ == '__main__':
    rm_garbage()
