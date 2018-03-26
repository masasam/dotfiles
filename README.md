# My dotfiles based on Makefile

## Synopsis

![emacs](https://raw.githubusercontent.com/masasam/image/image/emacs.png)

![mutt](https://raw.githubusercontent.com/masasam/image/image/mutt.png)

## Let's build environment with Makefile

This dotfiles is for Archlinux.

Since there is no such as a distribution without make,

if you make [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) you can correspond to any distribution.

Let's make a [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) immediately.

### With Makefile, such a good thing

Easy to build development environment with

    make install

I never have to worry about setting my PC again.

### Deploying dotfiles can be done in a moment

After make install

You can deploy dotfiles with

    make init

### With Makefile, you will be able to recover your usual environment in 30 minutes

![make](https://raw.githubusercontent.com/masasam/image/image/make.png)

Once after creating the environment

    make backup

Since the arch linux packages list that was installed at will be backed up to archlinux directry,

you can recover the arch linux environment with

	make recover

You can do 'make recover' or 'make install' for the second and subsequent builds.

Please select your favorite one.

If [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) is completed, you should be able to restore in 30 minutes in either case.

    make init

Then dotfiles will be deployed and restored.

You can deploy all with

	make allinit

Keep Dropbox synchronized before doing make allinit.
	
You can install all with

	make allinstall

You can backup packages all with

	make allbackup

You can update packages all with

	make allupdate

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

  Even if it gets broken, I made a [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) so I can return in half an hour and it's unbeatable.

- Arch linux is good because it is difficult for my PC's development environment to be old packages.

- I like customization but if customization is done too much, it is not good because it can not receive the benefit of the community. Since Archlinux is unsuitable for excessive customization, it is fit to me.

  In principle the package of Arch is a policy to build from the source of vanilla (Vanilla means that it does not apply its own patch for arch linux)

  It is good because Arch linux unique problems are unlikely.

- Arch linux is lightweight because there is no extra thing.

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

Connect internet with wifi

    ip link
    rfkill list
    rfkill unblock 0
    wifi-menu wlp0s29f7u1

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

vi /etc/locale.gen

	en_US.UTF-8 UTF-8
	ja_JP.UTF-8 UTF-8

Next execute

    locale-gen

Shell is in English environment

    export LANG=C

This neighborhood will be UTF-8

    echo LANG=ja_JP.UTF-8 > /etc/locale.conf

Time zone example

	ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
	ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime

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

Uncomment comment out following

	Defaults env_keep += “ HOME ”
	%wheel ALL=(ALL) ALL

Set boot loader

    pacman -S grub
    grub-install --recheck /dev/sda
    grub-mkconfig -o /boot/grub/grub.cfg

#### Prepare drivers and Xorg Gnome wifi

Install drivers that match your environment

    lspci | grep VGA
    pacman -S xf86-video-intel libva-intel-driver
    pacman -S xorg-server xorg-apps

Gnome can be put as small as necessary

    pacman -S gnome-backgrounds
	pacman -S gnome-control-center
	pacman -S gnome-keyring
	pacman -S nautilus

Terminal uses termite and urxvt

	sudo pacman -S termite termite-terminfo
	sudo pacman -S rxvt-unicode

Enable graphical login with gdm

    pacman -S gdm
    systemctl enable gdm.service

Preparing the net environment

After using NetworkManager, use it with wifi.
You can not wifi unless you turn off dhcpcd.

    pacman -S networkmanager
    systemctl disable dhcpcd.service
    systemctl enable NetworkManager.service
    pacman -S otf-ipafont
    exit
    reboot

#### Login with ${USER} to arrange home directory

    sudo pacman -S xdg-user-dirs
    LANG=C xdg-user-dirs-update --force
    sudo pacman -S zsh git
    sudo pacman -S chromium

Install yaourt
vim /etc/pacman.conf

    [archlinuxfr]
    SigLevel = Never
    Server = http://repo.archlinux.fr/$arch

or
	
	curl https://raw.githubusercontent.com/masasam/dotfiles/master/archlinux/archlinuxfr >> /etc/pacman.conf

Synchronize yaourt latest

    sudo pacman -Syy
    sudo pacman -S yaourt
    sudo pacman --sync --refresh yaourt
    yaourt -Syua
	
Install dropbox and sync

    yaourt -S dropbox
    sudo pacman -S nautilus-dropbox
	dropbox

Preparing dotfiles

    mkdir -p ~/src/github.com/masasam
    cd src/github.com/masasam
	git clone https://github.com/masasam/dotfiles.git
	cd dotfiles
	make install
	make init

	# Below is for posting images of github
	cd ~/Pictures
	git clone -b image git@github.com:masasam/image.git

#### ctrl key

	dconf write /org/gnome/desktop/input-sources/xkb-options \'ctrl:swapcaps\'

	dconf write /org/gnome/desktop/interface/gtk-key-theme \'Emacs\'

--------------------------------------

You can make install from here

--------------------------------------

## Development environment install

#### Install using pacman

    sudo pacman -S firefox firefox-i18n-ja
    sudo pacman -S sylpheed emacs curl xsel openssh tmux
    sudo pacman -S zsh-completions keychain
    sudo pacman -S powertop gimp unrar
    sudo pacman -S file-roller xclip atool evince inkscape
    sudo pacman -S cifs-utils gvfs gvfs-smb eog lhasa lzop
    sudo pacman -S seahorse the_silver_searcher
    sudo pacman -S cups-pdf htop neovim go pkgfile rsync elixir
	sudo pacman -S nodejs whois nmap poppler-data ffmpeg 
	sudo pacman -S aspell aspell-en httperf asciidoc sbcl
	sudo pacman -S gdb hub wmctrl gpaste pkgstats
	sudo pacman -S linux-docs pwgen gauche screen ipcalc
	sudo pacman -S arch-install-scripts ctags parallel
	sudo pacman -S pandoc texlive-langjapanese texlive-latexextra
	sudo pacman -S shellcheck php cscope typescript
	sudo pacman -S noto-fonts-cjk arc-gtk-theme jq dnsmasq
	sudo pacman -S docker zsh-syntax-highlighting
	sudo pacman -S npm llvm llvm-libs lldb hdparm rxvt-unicode 
	sudo pacman -S mariadb-clients postgresql-libs tig lsof fzf
	sudo pacman -S debootstrap tcpdump pdfgrep
	sudo pacman -S alsa-utils mlocate traceroute hugo mpv jhead
	sudo pacman -S nethogs optipng jpegoptim noto-fonts-emoji
	sudo pacman -S debian-archive-keyring tree python-pip
	sudo pacman -S mathjax strace valgrind phantomjs p7zip unace
	sudo pacman -S yarn geckodriver w3m neomutt iperf redis
	sudo pacman -S highlight lynx elinks mediainfo cpio flameshot
	sudo pacman -S oath-toolkit imagemagick
	sudo pacman -S bookworm ruby ruby-rdoc

# dconf setting

	dconf write /org/gnome/desktop/interface/gtk-theme \'Arc-Dark\'

	dconf write /org/gnome/desktop/interface/clock-show-date \'True\'

## Activity

![activity](https://raw.githubusercontent.com/masasam/image/image/activity.png)

Activities> Settings> Search

Turn it all off

Activities> Settings> Keyboard> Shortcut

>Display System - Activity screen [Alt + Space]

>Ctrl-u

If you make a mistake on the letters, erase all with Ctrl-u

#### Install using yaourt

	yaourt -S drone-cli
	yaourt -S git-secrets
	yaourt -S global
	yaourt -S google-cloud-sdk
	yaourt -S goobook-git
	yaourt -S ibus-mozc
	yaourt -S mozc
	yaourt -S nkf
	yaourt -S nodenv
	yaourt -S peek
	yaourt -S rbenv
	yaourt -S ruby-build
	yaourt -S screenkey

##### Install using pip

	pip install --user --upgrade pip
	pip install --user virtualenv
	pip install --user ansible
	pip install --user ansible-lint
	pip install --user docker-compose
	pip install --user virtualenvwrapper
	pip install --user seaborn
	pip install --user ipywidgets
	pip install --user scikit-learn
	pip install --user scipy
	pip install --user pandas
	pip install --user matplotlib
	pip install --user jupyter
	pip install --user neovim
	pip install --user pylint
	pip install --user jedi
	pip install --user autopep8
	pip install --user flake8
	pip install --user pyflakes
	pip install --user pygments
	pip install --user speedtest-cli
	pip install --user selenium
	pip install --user ansible-container
	pip install --user scrapy
	pip install --user mycli
	pip install --user pgcli
	pip install --user pip-review
	pip install --user yapf
	pip install --user pydoc_utils
	pip install --user rope
	pip install --user importmagic
	pip install --user awscli
	pip install --user progressbar2
	pip install --user ranger-fm
	pip install --user rtv
	pip install --user jupyterthemes
	pip install --user httpie
	pip install --user trash-cli
	pip install --user jupyterlab
	pip install --user cheat
	pip install --user faker

#### Install using golang

	go get -u -v github.com/nsf/gocode
	go get -u -v github.com/rogpeppe/godef
	go get -u -v golang.org/x/tools/cmd/goimports
	go get -u -v golang.org/x/tools/cmd/godoc
	go get -u -v github.com/josharian/impl
	go get -u -v github.com/jstemmer/gotags
	go get -u -v github.com/golang/dep/cmd/dep
	go get -u -v github.com/motemen/ghq
	go get -u -v github.com/sonatard/ghs
	go get -u -v github.com/kyoshidajp/ghkw
	go get -u -v github.com/hashicorp/packer

#### Install using yarn

	yarn global add npm
	yarn global add tern
	yarn global add jshint
	yarn global add eslint
	yarn global add babel-eslint
	yarn global add eslint-plugin-react
	yarn global add vue-language-server
	yarn global add vue-cli
	yarn global add create-react-app
	yarn global add create-component-app
	yarn global add prettier
	yarn global add firebase-tools
	yarn global add heroku-cli

#### rbenv rails

	yaourt -S rbenv
	yaourt -S ruby-build
	rbenv install 2.5.0

#### Create rails app

	rbenv global 2.5.0
	rbenv rehash
	mkdir -p ${HOME}/src/github.com/masasam/myapp
	cd ${HOME}/src/github.com/masasam/myapp
	rbenv local 2.5.0
	bundle init
	echo "gem 'rails', '~> 5.2.0.rc2'" >> Gemfile
	bundle install --path vendor/bundle
	bundle exec rails new -B --webpack=react --database=mysql --skip-test .
	bundle install
	bundle exec rails webpacker:install

#### Install using rust

	sudo pacman -S cmake
	curl -sSf https://sh.rustup.rs | sh
	cargo install racer
	cargo install cargo-update
	cargo install cargo-script
	cargo install cargo-edit
	cargo install ripgrep
	cargo install exa
	cargo install fd-find
	cargo install xsv
	cargo install hyperfine
	rustup component add rust-src

#### Install using cask

    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
    cd .emacs.d
    cask upgrade
    cask install
    cask update

# Terminal

![terminal](https://raw.githubusercontent.com/masasam/image/image/tmux.png)

Terminal uses termite and urxvt see

	.config/termite
	.Xresources

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

## How to test Makefile

#### When using Makefile

Test this [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) using docker

	make test

Test this [Makefile](https://github.com/masasam/dotfiles/blob/master/Makefile) using docker without Dropbox

	make testsimple

#### When executing manually

1.Build this Dockerfile

	docker build -t dotfiles /home/${USER}/src/github.com/masasam/dotfiles

2.Run 'docker run' mounting the dropbox directory

	docker run -t -i -v /home/${USER}/Dropbox:/home/${USER}/Dropbox:cached --name arch dotfiles /bin/bash

3.Execute the following command in the docker container

	cd /home/${USER}/src/github.com/masasam/dotfiles
	make install
	make init
