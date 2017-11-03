# My dotfiles based on Makefile

## Synopsis

![emacs](https://raw.githubusercontent.com/masasam/image/image/emacs.png)

## Let's build environment with Makefile

This dotfiles is for Archlinux.

Since there is no such as a distribution without make,

if you make Makefile you can correspond to any distribution.

Let's make a Makefile immediately.

### With Makefile, such a good thing

Easy to build development environment with

    make install

I never have to worry about setting my PC again.

### Deploying dotfiles can be done in a moment

After make install

You can deploy dotfiles with.

    make init

Keep Dropbox synchronized before doing make init.

### With Makefile, you will be able to recover your usual environment in 30 minutes

![make](https://raw.githubusercontent.com/masasam/image/image/make.png)

Once after creating the environment

    make backup

Since the arch linux package list that was installed at will be backed up to archlinux directry,

you can recover the arch linux environment with.

    make recover

You can do 'make recover' or 'make install' for the second and subsequent builds.

Please select your favorite one.

If Makefile is completed, you should be able to restore in 30 minutes in either case.

After Dropbox Sync

    make init

Then dotfiles will be deployed and restored.

#### Criteria of things managed by Dropbox

- What can not be placed on github

   Public key in .ssh etc.

- Because it makes a lot of update file, it is troublesome to synchronize with github

    .zsh_history
	.mozc

- To protect data

   Sylpheed configuration file and mail data.

   As mail arrives, it will be synchronized to dropbox so you don't have to think about backup.

Don't forget to make dropbox 2 factor authentication.

# ArchLinux install

Why Arch linux ?

- Unless your PC breaks, arch linux is a rolling release so you don't have to reinstall it.

  Even if it gets broken, I made a Makefile so I can return in half an hour and it's unbeatable.

- Arch linux is good because it is difficult for my PC's development environment to be old package.

- I like customization but if customization is done too much, it is not good because it can not receive the benefit of the community. Since Archlinux is unsuitable for excessive customization, it is fit to me.

  In principle the package of Arch is a policy to build from the source of vanilla (Vanilla means that it does not apply its own patch for arch linux)

  It is good because Arch linux unique problems are unlikely.

- Arch linux is lightweight because there is no extra thing. After installing Emacs Terminal chromium and launching an image htop

![top](https://raw.githubusercontent.com/masasam/image/image/top.png)

Download Arch linux.

https://www.archlinux.org/releng/releases/

Create USB installation media.

    dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx && sync

![baobao](https://raw.githubusercontent.com/masasam/image/image/baobao.png)

SSD has only 120 G, but it is sufficient for the environment that uses arch linux and emacs.

#### Boot in USB memory

Change it to boot usb in BIOS and boot.

Partitioning

* UEFI can not use thinkpad so BIOS

  Choose according to your hardware.

* Since it is GPT, it is partition / only

  '/ Only' may be easier.

* With SSD it's 8G memory so there's no swap

gdisk /dev/sda

    1 sda1  BIOS boot partition(EF02) 1007KB
    2 sda2 / All remaining

Format and mount with ext4

    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt

vi /etc/pacman.d/mirrorlist

    Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch

Make sure the earliest mirror is selected.

Install bese bese-devel of arch

    pacstrap /mnt base base-devel

Generate fstab

    genfstab -U -p /mnt >> /mnt/etc/fstab

Mount and log in as bash login shell

    arch-chroot /mnt /bin/bash

Set the host name

    echo thinkpad > /etc/hostname

Set the locale

vi /etc/locale.gen

>en_US.UTF-8 UTF-8
>ja_JP.UTF-8 UTF-8

    locale-gen

Shell is in English environment

    export LANG=C

This neighborhood will be UTF-8

    echo LANG=ja_JP.UTF-8 > /etc/locale.conf

Time adjustment

    hwclock --systohc --utc

Generate kernel image

    mkinitcpio -p linux

Generate user

    useradd -m -G wheel -s /bin/bash ${USER}

Set password

    passwd ${USER}

Set groups and permissions

    pacman -S vim
    visudo

>Defaults env_keep += “ HOME ”
>%wheel ALL=(ALL) ALL

Uncomment comment out

Set boot loader

    pacman -S grub
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

#### Prepare drivers and Xorg Gnome wifi

As bash complements work

    pacman -S bash-completion

Install drivers that match your environment

    lspci | grep VGA
    pacman -S xf86-video-intel libva-intel-driver
    pacman -S xorg-server xorg-apps xorg-xinit xorg-xclock

Gnome can be put as small as necessary

    pacman -S gnome-backgrounds
	pacman -S gnome-control-center
	pacman -S gnome-keyring
	pacman -S gnome-shell-extensions
	pacman -S gnome-tweak-tool
	pacman -S nautilus

Terminal uses termite and urxvt

	sudo pacman -S termite
	sudo pacman -S rxvt-unicode

Enable graphical login with gdm

    pacman -S gdm
    systemctl enable gdm.service

Install yaourt
vim /etc/pacman.conf

    [archlinuxfr]
    SigLevel = Never
    Server = http://repo.archlinux.fr/$arch

Synchronize yaourt latest

    sudo pacman -Syy
    sudo pacman -S yaourt
    sudo pacman --sync --refresh yaourt
    yaourt -Syua

Preparing the net environment

After using NetworkManager, use it with wifi.
You can not wifi unless you turn off dhcpcd.

    sudo pacman -S networkmanager
    systemctl disable dhcpcd.service
    systemctl enable NetworkManager.service
    reboot

#### Login with ${USER} to arrange home directory

    sudo pacman -S xdg-user-dirs
    LANG=C xdg-user-dirs-update --force
    sudo pacman -S zsh git vim

Install dropbox and sync

    sudo pacman -S dropbox
    sudo pacman -S nautilus-dropbox
	dropbox

Preparing dotfiles

    mkdir -p ~/src/github.com/masasam
    cd src/github.com/masasam
	git clone git@github.com:masasam/dotfiles.git
	cd dotfiles
	make install
	make init

	# Below is for posting images of github
	cd ~/Pictures
	git clone -b image git@github.com:masasam/image.git

 ※ When git cloning with ssh, it is necessary to put the public key first in .ssh

--------------------------------------

You can make install from here

--------------------------------------

## Development environment install

Install what enters with pacman

    sudo pacman -S firefox  firefox-i18n-ja
    sudo pacman -S otf-ipafont
    sudo pacman -S openssh
    sudo pacman -S sylpheed
    sudo pacman -S zsh-completions
    sudo pacman -S emacs
    sudo pacman -S curl
    sudo pacman -S tmux
    sudo pacman -S keychain
    sudo pacman -S gnome-tweak-tool
    sudo pacman -S xsel
    sudo pacman -S archlinux-wallpaper
    sudo pacman -S evince inkscape gimp unrar
    sudo pacman -S file-roller
    sudo pacman -S xclip
    sudo pacman -S atool
    sudo pacman -S trash-cli
    sudo pacman -S the_silver_searcher
    sudo pacman -S powertop
    sudo pacman -S cifs-utils
    sudo pacman -S gvfs gvfs-smb
    sudo pacman -S seahorse gnome-keyring
    sudo pacman -S cups-pdf
    sudo pacman -S eog
    sudo pacman -S mcomix
    sudo pacman -S libreoffice-fresh-ja
    sudo pacman -S go pkgfile rsync elixir
	sudo pacman -S nodejs phantomjs whois nmap poppler-data
	sudo pacman -S rtmpdump ffmpeg asciidoc sbcl
	sudo pacman -S aspell aspell-en httperf
	sudo pacman -S gdb ripgrep hub wmctrl
	sudo pacman -S linux-docs ansible pwgen pygmentize
	sudo pacman -S arch-install-scripts
	sudo pacman -S htop
	sudo pacman -S neovim
	sudo pacman -S pandoc texlive-langjapanese texlive-latexextra ctags python-pygments
	sudo pacman -S python-neovim python2-neovim
	sudo pacman -S rust cargo
	sudo pacman -S noto-fonts-cjk arc-gtk-theme jq
	sudo pacman -S docker docker-compose zsh-syntax-highlighting
	sudo pacman -S eslint shellcheck python-pyflakes python-jedi autopep8 python-virtualenv
	sudo pacman -S python-pylint flake8
	sudo pacman -S npm llvm llvm-libs lldb hdparm rxvt-unicode dnsmasq typescript php cscope
	sudo pacman -S speedtest-cli cpanminus mariadb-clients postgresql-libs tig lsof fzf
	sudo pacman -S debootstrap tcpdump chromium bashdb pdfgrep ack parallel
	sudo pacman -S alsa-utils mlocate traceroute aws-cli hugo mpv jhead gpaste pkgstats
	sudo pacman -S nethogs optipng jpegoptim noto-fonts-emoji gauche screen ipcalc
	sudo pacman -S debian-archive-keyring slack-desktop jupyter-notebook python-ipywidgets
	sudo pacman -S mathjax matplotlib python-matplotlib python-pandas strace valgrind
	sudo pacman -S python-scikit-learn python-scipy python-pip python-virtualenv

Install what you put in yaourt

	yaourt peco
	yaourt ttf-cica
	yaourt ttf-myrica
	yaourt ttf-ricty
	yaourt profile-sync-daemon
	yaourt man-pages-ja
	yaourt global
	yaourt ghq
	yaourt casperjs
	yaourt nkf
	yaourt ctop
	yaourt ibus-mozc
	yaourt mozc
	yaourt google-cloud-sdk
	yaourt screenkey
	yaourt git-secrets
	yaourt quicklisp

#### golang npm rust

    ghq get -p github.com/nsf/gocode
    ghq get -p github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	ghq get -p josharian/impl
	ghq get -p github.com/motemen/ghq
	ghq get -p phildawes/racer
	sudo npm install -g tern
	sudo npm install -g jshint
	curl https://sh.rustup.rs -sSf | sh
	source $HOME/.cargo/env
	cargo install rustfmt
	cargo install racer
	cargo install cargo-script
	cpanm RPC::EPC::Service DBI DBD::SQLite DBD::Pg DBD::mysql

#### cask install

    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
    cd .emacs.d
    cask upgrade
    cask install
    cask update

#### Trackpoint

Install Thinkpad specific ones

~/.xinitrc

    tpset() { xinput set-prop "TPPS/2 IBM TrackPoint" "$@"; }

    tpset "Evdev Wheel Emulation" 1
    tpset "Evdev Wheel Emulation Button" 2
    tpset "Evdev Wheel Emulation Timeout" 200
    tpset "Evdev Wheel Emulation Axes" 6 7 4 5
    tpset "Device Accel Constant Deceleration" 0.95

sudo vim /etc/udev/rules.d/10-trackpoint.rules

    ACTION=="add", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/sensitivity}="240"

sudo vim /etc/X11/xorg.conf.d/20-thinkpad.conf

    Section "InputClass"
        Identifier	"Trackpoint Wheel Emulation"
        MatchProduct	"TPPS/2 IBM TrackPoint"
        MatchDevicePath	"/dev/input/event*"
        Option		"EmulateWheel"		"true"
        Option		"EmulateWheelButton"	"2"
        Option		"Emulate3Buttons"	"false"
        Option		"XAxisMapping"		"6 7"
        Option		"YAxisMapping"		"4 5"
    EndSection

# Tweak Tool

Detailed setting of gnome etc.

![TweakTool](https://raw.githubusercontent.com/masasam/image/image/tweaktool.png)

* Key theme

>Emacs

* Ctrl key position

>Use Caps Lock as Ctrl

* Key sequence for terminating X server

>Ctrl Alt Backspace

* Caps Lock behavior

Caps Lock is also a Ctrl

* Fix workspace to 1

* Power supply

    When AC power is connected Blank.

    Don't suspend on lid close.

# Terminal

![terminal](https://raw.githubusercontent.com/masasam/image/image/terminal.png)

Terminal uses termite and urxvt see

	.config/termite
	.Xresources

#### .bashrc

If you customize zsh by making zsh the default shell It may not be possible to login and it may be very troubling.

So when tmux starts up, write it in tmux.conf to start zsh.
Keep the default shell bash.

    echo "alias tmuxstart='tmux new-session -A -s main'" >> ~/.bashrc
    echo "export HISTCONTROL=erasedups" >> ${HOME}/.bashrc

When started with tmuxstart, if you have a tmux session, you use it.

If you don't have a tmux session, tmux will start up in a new session.

# Powertop

Reduce power consumption to save energy.

Don't send power to unused system bus.

>sudo pacman -S powertop

Since it becomes invalid when restarting, It will set the following.

>sudo powertop --calibrate

sudo vim /etc/systemd/system/powertop.service

>[Unit]
>Description=PowerTOP auto tune

>[Service]
>Type=idle
>Environment="TERM=dumb"
>ExecStart=/usr/sbin/powertop --auto-tune

>[Install]
>WantedBy=multi-user.target

    sudo systemctl enable powertop
    reboot

![PowerTop](https://raw.githubusercontent.com/masasam/image/image/powertop.png)

Succeed if all of this tab is Good

# Profile-Sync-Daemon

Chromium, firefox cache and profile is fast when it put on memory.

As the frequency of synchronization to the disk decreases, it also has the effect of preventing consumption of the SSD.

>yaourt profile-sync-daemon

visudo

    ${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper

>psd p

vim ~/.config/psd/psd.conf

    USE_OVERLAYFS="yes"
    BROWSERS="chromium firefox"

>psd p

#### To automatically start psd

>systemctl --user enable psd.service
>reboot

Check if it is moving

After restart

>systemctl --user status psd

# Enable DNS cache

Install dnsmasq

	sudo pacman -S dnsmasq

/etc/NetworkManager/NetworkManager.conf

	[main]
	dns=dnsmasq

When restarting NetworkManager, dnsmasq is set to be automatically usable.

	sudo systemctl restart NetworkManager

Do the same DNS lookup twice on drill command.

![dnsmasq](https://raw.githubusercontent.com/masasam/image/image/dnsmasq.png)

## Don't suspend even if closing the lid

It does not suspend, because startup is fast

>/etc/systemd/logind.conf

    #HandleLidSwitch=suspend
    HandleLidSwitch=ignore

Then restart the logind service

    systemctl restart systemd-logind

## Activity

![activity](https://raw.githubusercontent.com/masasam/image/image/activity.png)

Activities> Settings> Search

Turn it all off

Activities> Settings> Keyboard> Shortcut

>Display System - Activity screen [Alt + Space]

>Ctrl-u

If you make a mistake on the letters, erase all with Ctrl-u

# Firefox

#### Gnome Shell Extention

>Dash to Dock
>TopIcons Plus
>Easyscreencast

#### stylish

Use the following themes

<https://userstyles.org/styles/23516/midnight-surfing-global-dark-style>

Defaultfullzoomlevel to 125%

# Chromium
Change the default size to 125%

<https://chrome.google.com/webstore/detail/change-colors/jbmkekhehjedonbhoikhhkmlapalklgn>

Based on black screen with change-colors.

# Mozc

ibus-mozc

Make input sources mozc only for region and language.

Because it is a US keyboard Japanese conversion is control + space

Since I am wearing emacs, I use mozc with shift + Space

Key setting is based on Kotoeri ← closest to emacs key binding

>「Input before conversion」「Shift+Space」「Disable IME」
>「Converting」「Shift+Space」「Disable IME」
>「Direct input」「Shift+Space」「Enable IME」
>「No input character」「Shift+Space」「Disable IME」
>Delete other Shift-space entangled shortcuts.

reboot

Once mozc is set up

    ln -sfn ~/Dropbox/mozc/.mozc ~/.mozc

And set the mozc setting to dropbox

With this it will not have to be set again

# Sylpheed

Sylpheed on initial startup I will be asked for the Mail folder

> ~/Dropbox/sylpheed/Mail

When changing the Mail folder except when it is started for the first time

Specify the Mail folder with.

> vim ~/.sylpheed-2.0/folderlist.xml

    <folder type="mh" name="Mailbox" path="/home/${USER}/Dropbox/sylpheed/Mail">

Because it is a file format of 1 mail 1 file If you synchronize mail immediately with Dropbox There is no worry of data lost.

#### Sylpheed configuration file

Once the setting is finished Let's cast it to the dropbox and try not to do it again.

    ln -sfn ~/Dropbox/sylpheed/.sylpheed-2.0 ~/.sylpheed-2.0

Store it in the tray icon when minimized If you set it

Alt - Tab

It's okay if sylpheed does not come out

### Setting font

Set the following with gnome-tweak-tool

Font

- Window title  Cantarell 11
- interface   Noto Sans CJK JP Regular 11
- Document   Sans Regular 11
- Equal width    Monospace Regular 11

## How to test Makefile

1.Build this Dockerfile

	docker build -t dotfiles /home/${USER}/src/github.com/masasam/dotfiles

2.Run docker run and execute the following command in the docker container

	docker run -t -i -v /home/${USER}/Dropbox:/home/${USER}/Dropbox:cached --name arch dotfiles /bin/bash
	cd /home/${USER}/src/github.com/masasam/dotfiles
	make install
	make init
