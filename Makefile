init: ## deploy this dotfiles
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/redshift.conf   ${HOME}/.config/redshift.conf
	ln -vsfn ${PWD}/.peco   ${HOME}/.peco
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	ln -vsfn ${HOME}/Dropbox/ssh   ${HOME}/.ssh
	ln -vsfn ${HOME}/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	ln -vsfn ${HOME}/Dropbox/mozc/.mozc   ${HOME}/.mozc
	chmod 600   ${HOME}/.ssh/id_rsa
	cd ${HOME}/.emacs.d/;	  cask upgrade;	  cask install

update: ## update cask depend on melpa
	cd ${HOME}/.emacs.d/;	  cask upgrade;   cask update

sync: ## sync github
	git pull
	git push

install: ## install development environment powerd by arch linux
	export GOPATH=${HOME}/go
	export PATH="$PATH:$GOPATH/bin"
	${PWD}/bin/continue.sh && \
	echo "alias screenstart='screen -D -RR'" >> ${HOME}/.bashrc
	echo "alias tmuxstart='tmux new-session -A -s main'" >> ${HOME}/.bashrc
	sudo pacman -S go zsh git vim dropbox nautilus-dropbox ibus-mozc mozc tmux keychain  \
	gnome-tweak-tool xsel sylpheed emacs curl archlinux-wallpaper evince inkscape gimp unrar \
	file-roller vlc xclip atool trash-cli the_silver_searcher powertop cifs-utils \
	gvfs gvfs-smb seahorse gnome-keyring cups-pdf redshift eog mcomix libreoffice-fresh-ja \
	firefox firefox-i18n-ja otf-ipafont openssh pkgfile baobab dconf-editor 
	mkdir -p ${HOME}/go/{bin,src}
	go get -u github.com/nsf/gocode
	go get -u github.com/rogpeppe/godef
	yaourt google-chrome
	yaourt cask
	yaourt peco
	yaourt noto-fonts-cjk
	yaourt ricty
	yaourt profile-sync-daemon
	yaourt man-pages-ja
	yaourt global
	sudo cp -R ${HOME}/Dropbox/arch/OSX-Arc-Shadow/ /usr/share/themes/
	sudo pkgfile --update

test: ## print environment value
	export GOPATH=${HOME}/go
	export PATH="${PATH}:${GOPATH}/bin"
	printenv

all: init update sync install test help

.PHONY: all

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
