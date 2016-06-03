#!/bin/bash
echo "alias screenstart='screen -D -RR'" >> ~/.bashrc
echo "alias tmuxstart='tmux new-session -A -s main'" >> ~/.bashrc

sudo apt-get install build-essential ubuntu-restricted-extras exuberant-ctags git traceroute \
tig nmap vim nkf xsel htop keychain zsh apache2-utils colordiff \
cifs-utils php7.0-cli screen xclip iotop parcellite vlc \
clisp sbcl sbcl-doc hyperspec hardinfo manpages-ja manpages-ja-dev \
inkscape p7zip rar shutter cups-pdf ntfs-config gparted trash-cli \
dstat testdisk gimp whois mypaint powertop lv curl silversearcher-ag discount \
byzanz ngrep tcpdump paco sylpheed atool tmux \
autoconf automake gcc make ncurses-dev texinfo libx11-dev libxpm-dev \
libjpeg-dev libpng-dev libgif-dev libtiff-dev libncurses-dev libgtk-3-dev
