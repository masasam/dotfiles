init: ## Initial deploy dotfiles
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.vimrc   ${HOME}/.vimrc
	ln -vsf ${PWD}/.bashrc   ${HOME}/.bashrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.npmrc   ${HOME}/.npmrc
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/.Xresources   ${HOME}/.Xresources
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
	sudo ln -vsf ${PWD}/etc/systemd/system/powertop.service   /etc/systemd/system/powertop.service
	sudo mkdir -p /etc/NetworkManager
	sudo ln -vsf ${PWD}/etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
	sudo mkdir -p /etc/libreoffice
	sudo ln -vsf ${PWD}/etc/libreoffice/sofficerc /etc/libreoffice/sofficerc
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

install: ## Install development environment for arch linux
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox tmux keychain bashdb \
	zsh-completions gnome-tweak-tool xsel emacs evince unrar seahorse hugo mpv \
	archlinux-wallpaper inkscape file-roller xclip atool debootstrap valgrind \
	the_silver_searcher powertop cifs-utils gvfs gvfs-smb libreoffice-fresh-ja \
	gnome-keyring cups-pdf eog mcomix openssh firefox firefox-i18n-ja gimp strace \
	otf-ipafont pkgfile baobab dconf-editor rsync elixir nodejs phantomjs whois \
	nmap poppler-data rtmpdump ffmpeg asciidoc sbcl docker aspell aspell-en ack \
	gdb ripgrep hub wmctrl pwgen linux-docs ansible htop mariadb-clients tcpdump \
	pygmentize arch-install-scripts termite neovim pandoc jq sylpheed pkgstats \
	texlive-langjapanese yarn texlive-latexextra ctags python-pygments hdparm \
	python-neovim python2-neovim noto-fonts-cjk arc-gtk-theme networkmanager npm \
	zsh-syntax-highlighting xorg-apps shellcheck python-pyflakes php typescript \
	python-jedi autopep8 python-virtualenv flake8 llvm llvm-libs lldb chromium \
	python-pylint dnsmasq cscope speedtest-cli lsof postgresql-libs tig pdfgrep \
	curl docker-compose parallel alsa-utils mlocate traceroute rust-racer jhead \
	noto-fonts-emoji rust cargo rustup rustfmt gpaste nethogs optipng jpegoptim \
	gauche screen ipcalc slack-desktop debian-archive-keyring jupyter-notebook \
	aws-cli bash-completion mathjax python-matplotlib python-pandas python-scipy \
	python-scikit-learn gnu-netcat python-ipywidgets urxvt-perls cmatrix expect \
	python-pip python-virtualenv python-seaborn
	sudo pkgfile --update

aur: ## Install AUR packages with yaourt
	yaourt casperjs
	yaourt chrome-gnome-shell-git
	yaourt ctop
	yaourt direnv
	yaourt ghq
	yaourt git-secrets
	yaourt global
	yaourt google-cloud-sdk
	yaourt ibus-mozc
	yaourt man-pages-ja
	yaourt mozc
	yaourt nkf
	yaourt peco
	yaourt profile-sync-daemon
	yaourt quicklisp
	yaourt screenkey
	yaourt ttf-cica
	yaourt ttf-myrica
	yaourt ttf-ricty
	yaourt yum

caskinit: ## Initial cask
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

rubygems: ## Install rubygems package
	gem install bundle
	gem install jekyll
	gem install pry

npminit: ## Install node package
	mkdir -p ${HOME}/.node_modules
	export npm_config_prefix=${HOME}/.node_modules
	yarn global add npm tern jshint --prefix ~/.node_modules
	yarn global add eslint babel-eslint eslint-plugin-react --prefix ~/.node_modules

goinstall: ## Install go packages
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	mkdir -p ${HOME}/{bin,src}
	go get -u github.com/nsf/gocode
	go get -u github.com/rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/tools/cmd/godoc
	go get -u github.com/josharian/impl
	go get -u github.com/jstemmer/gotags
	go get -u github.com/golang/dep/cmd/dep

cargoinstall: ## Install cargo package
	cargo install cargo-script

backup: ## Backup archlinux packages
	mkdir -p ${HOME}/src/github.com/masasam/dotfiles/archlinux
	pacman -Qqen > ${HOME}/src/github.com/masasam/dotfiles/archlinux/pacmanlist
	pacman -Qnq > ${HOME}/src/github.com/masasam/dotfiles/archlinux/allpacmanlist
	pacman -Qqem > ${HOME}/src/github.com/masasam/dotfiles/archlinux/yaourtlist

recover: ## Recovery from backup arch linux package
	sudo pacman -S --needed `cat ${HOME}/src/github.com/masasam/dotfiles/archlinux/pacmanlist`
	yaourt -S --needed $(DOY) `cat ${HOME}/src/github.com/masasam/dotfiles/archlinux/yaourtlist`

dockerinit: ## Docker initial setup
	sudo usermod -aG docker ${USER}
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	sudo systemctl stop docker.service
	sudo systemctl disable docker.service
	sudo ln -vsf ${PWD}/etc/docker/daemon.json   /etc/docker/daemon.json
	sudo systemctl start docker.service

psdinit: ## Profile-Sync-Daemon initial setup
	echo "${USER} ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper" | sudo EDITOR='tee -a' visudo
	systemctl --user enable psd.service

powertopinit: ## Powertop initial setup (Warning take a long time)
	sudo powertop --calibrate
	sudo systemctl enable powertop

updatedb: ## Update file datebase
	sudo updatedb

neovim: # Init neovim dein
	bash ${HOME}/.config/nvim/installer.sh ${HOME}/.config/nvim

all: aur backup cask caskinit dockerinit goinstall init install cargoinstall npminit rubygems psdinit powertopinit recover updatedb neovim help

.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
