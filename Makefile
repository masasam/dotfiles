DOP= `cat ${HOME}/Dropbox/arch/pacmanlist.txt`
DOY= `cat ${HOME}/Dropbox/arch/yaourtlist.txt`

init: ## deploy this dotfiles
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.tern-config   ${HOME}/.tern-config
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/.Xdefaults   ${HOME}/.Xdefaults
	ln -vsf ${PWD}/.aspell.conf   ${HOME}/.aspell.conf
	ln -vsf ${PWD}/.config/redshift.conf   ${HOME}/.config/redshift.conf
	ln -vsf ${PWD}/.config/psd/psd.conf   ${HOME}/.config/psd/psd.conf
	ln -vsf ${PWD}/.config/fish/conf.d/omf.fish   ${HOME}/.config/fish/conf.d/omf.fish
	ln -vsf ${PWD}/.config/clipit/clipitrc   ${HOME}/.config/clipit/clipitrc
	ln -vsf ${PWD}/.config/gtk-3.0/bookmarks   ${HOME}/.config/gtk-3.0/bookmarks
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
	test -L ${HOME}/.sylpheed-2.0 || rm -rf ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	test -L ${HOME}/.mozc || rm -rf ${HOME}/.mozc
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	chmod 600   ${HOME}/.ssh/id_rsa
	cd ${HOME}/.emacs.d/;   cask upgrade;   cask install

update: ## update cask depend on melpa
	cd ${HOME}/.emacs.d/;   cask upgrade;   cask update

install: ## install development environment powerd by arch linux
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	chmod u+x ${PWD}/bin/continue.sh
	${PWD}/bin/continue.sh && \
	cat ${HOME}/.bashrc | grep screenstart || echo "alias screenstart='screen -D -RR'" >> ${HOME}/.bashrc
	cat ${HOME}/.bashrc | grep tmuxstart || echo "alias tmuxstart='tmux new-session -A -s main'" >> ${HOME}/.bashrc
	cat ${HOME}/.bashrc | grep ignoredups || echo "export HISTCONTROL=erasedups" >> ${HOME}/.bashrc
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox tmux keychain zsh-completions \
	gnome-tweak-tool xsel sylpheed emacs curl archlinux-wallpaper evince inkscape gimp unrar \
	file-roller vlc xclip atool trash-cli the_silver_searcher screen powertop cifs-utils \
	gvfs gvfs-smb seahorse gnome-keyring cups-pdf redshift eog mcomix libreoffice-fresh-ja \
	firefox firefox-i18n-ja otf-ipafont openssh pkgfile baobab dconf-editor rsync elixir \
	nodejs phantomjs whois nmap poppler-data rtmpdump ffmpeg swftools fish sbcl docker \
	aspell aspell-en httperf gdb ripgrep hub wmctrl transmission-gtk linux-docs ansible \
	pwgen pygmentize arch-install-scripts lilyterm termite htop neovim youtube-dl pandoc \
	texlive-langjapanese texlive-latexextra ctags python-pygments python-neovim python2-neovim \
	rust cargo noto-fonts-cjk arc-gtk-theme slack-desktop jq zsh-syntax-highlighting python-pip \
	eslint shellcheck python-pyflakes python-jedi autopep8 python-virtualenv python-pylint \
	flake8 npm llvm llvm-libs lldb hdparm rxvt-unicode dnsmasq
	mkdir -p ${HOME}/{bin,src}
	yaourt google-chrome
	yaourt peco
	yaourt ttf-ricty
	yaourt profile-sync-daemon
	yaourt man-pages-ja
	yaourt global
	yaourt hugo
	yaourt ghq
	yaourt casperjs
	yaourt nkf
	yaourt osx-arc-shadow
	yaourt cmigemo-git
	yaourt ibus-mozc
	yaourt mozc
	yaourt clipit
	yaourt python-epc
	yaourt enpass-bin
	yaourt networkmanager-noscan
	sudo pkgfile --update
	git config --global ghq.root ~/src
	ghq get -p nsf/gocode
	ghq get -p rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	ghq get -p motemen/ghq
	ghq get -p jstemmer/gotags
	ghq get -p phildawes/racer
	sudo npm install -g tern
	sudo npm install -g jshint
	sudo pip install neovim
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

backup: ## backup arch linux package at dropbox
	mkdir -p ${HOME}/Dropbox/arch
	pacman -Qqen > ${HOME}/Dropbox/arch/pacmanlist.txt
	pacman -Qnq > ${HOME}/Dropbox/arch/allpacmanlist.txt
	pacman -Qqem > ${HOME}/Dropbox/arch/yaourtlist.txt

recover: ## recovery from backup arch linux package at dropbox
	sudo pacman -S --needed $(DOP)
	yaourt -S --needed $(DOY)
	cat ${HOME}/.bashrc | grep screenstart || echo "alias screenstart='screen -D -RR'" >> ${HOME}/.bashrc
	cat ${HOME}/.bashrc | grep tmuxstart || echo "alias tmuxstart='tmux new-session -A -s main'" >> ${HOME}/.bashrc
	cat ${HOME}/.bashrc | grep ignoredups || echo "export HISTCONTROL=ignoredups" >> ${HOME}/.bashrc
	mkdir -p ${HOME}/{bin,src}
	export GOPATH=${HOME}
	export PATH="$PATH:$GOPATH/bin"
	sudo pkgfile --update
	git config --global ghq.root ~/src
	ghq get -p nsf/gocode
	ghq get -p rogpeppe/godef
	go get -u golang.org/x/tools/cmd/goimports
	ghq get -p motemen/ghq
	ghq get -p jstemmer/gotags
	sudo npm install -g tern
	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

test: ## print environment value
	export GOPATH=${HOME}
	export PATH="${PATH}:${GOPATH}/bin"
	printenv

all: init update install test help backup recover

.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
