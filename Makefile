init: ## deploy this dotfiles
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf
	mkdir -p ${HOME}/.config
	ln -vsf ${HOME}/Dropbox/zsh/hub   ${HOME}/.config/hub
	mkdir -p ${HOME}/.docker
	ln -vsf ${HOME}/Dropbox/docker/config.json   ${HOME}/.docker/config.json
	ln -vsf ${PWD}/.config/screenkey.json ${HOME}/.config/screenkey.json
	mkdir -p ${HOME}/.config/psd
	ln -vsf ${PWD}/.config/psd/psd.conf   ${HOME}/.config/psd/psd.conf
	mkdir -p ${HOME}/.config/gtk-3.0
	ln -vsf ${PWD}/.config/gtk-3.0/bookmarks   ${HOME}/.config/gtk-3.0/bookmarks
	sudo ln -vsf ${PWD}/etc/pacman.conf   /etc/pacman.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/resolv.dnsmasq.conf   /etc/resolv.dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/dnsmasq/dnsmasq.conf   /etc/dnsmasq.conf
	sudo ln -vsf ${PWD}/etc/systemd/logind.conf   /etc/systemd/logind.conf
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo mkdir -p /etc/libreoffice
	sudo ln -vsf ${PWD}/etc/libreoffice/sofficerc /etc/libreoffice/sofficerc
	mkdir -p ${HOME}/.config/lilyterm
	ln -vsf ${PWD}/.config/lilyterm/default.conf   ${HOME}/.config/lilyterm/default.conf
	mkdir -p ${HOME}/.config/termite
	ln -vsf ${PWD}/.config/termite/config   ${HOME}/.config/termite/config
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${PWD}/.config/nvim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${PWD}/.config/nvim/installer.sh   ${HOME}/.config/nvim/installer.sh
	test -L ${HOME}/.peco || rm -rf ${HOME}/.peco
	ln -vsfn ${PWD}/.peco   ${HOME}/.peco
	test -L ${HOME}/.emacs.d || rm -rf ${HOME}/.emacs.d
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	test -L ${HOME}/.ssh || rm -rf ${HOME}/.ssh
	ln -vsfn ${HOME}/Dropbox/ssh   ${HOME}/.ssh
	mkdir -p ${HOME}/.local/share
	test -L ${HOME}/.local/share/keyrings || rm -rf ${HOME}/.local/share/keyrings
	ln -vsfn ${HOME}/Dropbox/passwd/keyrings   ${HOME}/.local/share/keyrings
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	chmod 600   ${HOME}/.ssh/id_rsa

install: ## install development environment for arch linux
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox tmux keychain bashdb \
	zsh-completions gnome-tweak-tool xsel emacs evince unrar seahorse hugo mpv \
	archlinux-wallpaper inkscape file-roller xclip atool trash-cli debootstrap \
	the_silver_searcher powertop cifs-utils gvfs gvfs-smb libreoffice-fresh-ja \
	gnome-keyring cups-pdf eog mcomix openssh firefox firefox-i18n-ja fzf gimp \
	otf-ipafont pkgfile baobab dconf-editor rsync elixir nodejs phantomjs whois \
	nmap poppler-data rtmpdump ffmpeg asciidoc sbcl docker aspell aspell-en ack \
	gdb ripgrep hub wmctrl pwgen linux-docs ansible htop mariadb-clients tcpdump \
	pygmentize arch-install-scripts lilyterm termite neovim pandoc jq sylpheed \
	texlive-langjapanese eslint texlive-latexextra ctags python-pygments hdparm \
	python-neovim python2-neovim noto-fonts-cjk arc-gtk-theme networkmanager npm \
	zsh-syntax-highlighting xorg-apps shellcheck python-pyflakes php typescript \
	python-jedi autopep8 python-virtualenv flake8 llvm llvm-libs lldb chromium \
	python-pylint dnsmasq cscope speedtest-cli lsof postgresql-libs tig pdfgrep \
	curl docker-compose parallel alsa-utils mlocate traceroute rust-racer jhead \
	aws-cli rust cargo rustup rustfmt gpaste pkgstats nethogs optipng jpegoptim
	mkdir -p ${HOME}/{bin,src}
	yaourt peco
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
	yaourt debian-archive-keyring
	yaourt slack-desktop
	yaourt git-secrets
	yaourt quicklisp
	sudo pkgfile --update
	git config --global ghq.root ~/src
	go get -u github.com/nsf/gocode
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	go get -u github.com/josharian/impl
	go get -u github.com/jstemmer/gotags
	sudo npm install -g tern
	sudo npm install -g jshint
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
	cargo install cargo-script

backup: ## backup archlinux installed packages
	mkdir -p ${HOME}/src/github.com/masasam/dotfiles/archlinux
	pacman -Qqen > ${HOME}/src/github.com/masasam/dotfiles/archlinux/pacmanlist
	pacman -Qnq > ${HOME}/src/github.com/masasam/dotfiles/archlinux/allpacmanlist
	pacman -Qqem > ${HOME}/src/github.com/masasam/dotfiles/archlinux/yaourtlist

recover: ## recovery from backup arch linux package
	sudo pacman -S --needed `cat ${HOME}/src/github.com/masasam/dotfiles/archlinux/pacmanlist`
	yaourt -S --needed $(DOY) `cat ${HOME}/src/github.com/masasam/dotfiles/archlinux/yaourtlist`
	mkdir -p ${HOME}/{bin,src}
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	sudo pkgfile --update
	git config --global ghq.root ~/src
	go get -u github.com/nsf/gocode
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	go get -u github.com/josharian/impl
	go get -u github.com/jstemmer/gotags
	sudo npm install -g tern
	sudo npm install -g jshint
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
	cargo install cargo-script

docker: ## docker setup
	sudo groupadd docker
	sudo usermod -aG docker masa
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	sudo systemctl stop docker.service
	sudo ln -vsf ${PWD}/etc/docker/daemon.json   /etc/docker/daemon.json
	sudo systemctl start docker.service

updatedb: ## file datebase update
	sudo updatedb

cask: ## install emacs package
	export PATH="$PATH:$HOME/.cask/bin"
	cd ${HOME}/.emacs.d/;   cask upgrade;   cask install

test: ## print environment value
	export GOPATH=${HOME}
	export PATH="${PATH}:${GOPATH}/bin"
	printenv

all: init update install test help backup recover

.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
