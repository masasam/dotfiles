init:
	ln -vsf ${PWD}/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/.screenrc   ${HOME}/.screenrc
	ln -vsf ${PWD}/.tmux.conf   ${HOME}/.tmux.conf
	ln -vsf ${PWD}/.xinitrc   ${HOME}/.xinitrc
	ln -vsf ${PWD}/redshift.conf   ${HOME}/.config/redshift.conf
	ln -vsfn ${PWD}/.peco   ${HOME}/.peco
	ln -vsfn ${PWD}/.emacs.d   ${HOME}/.emacs.d
	ln -vsfn ~/Dropbox/ssh   ${HOME}/.ssh
	ln -vsfn ~/Dropbox/sylpheed/.sylpheed-2.0   ${HOME}/.sylpheed-2.0
	ln -vsfn ~/Dropbox/mozc/.mozc   ${HOME}/.mozc
	chmod 600   ${HOME}/.ssh/id_rsa
	cd ${HOME}/.emacs.d/;	  cask upgrade;	  cask install
update:
	cd ${HOME}/.emacs.d/;	  cask upgrade;   cask update
sync:
	git pull
	git push
install:
	${PWD}/bin/continue.sh && \
	echo "alias screenstart='screen -D -RR'" >> ${HOME}/.bashrc
	echo "alias tmuxstart='tmux new-session -A -s main'" >> ${HOME}/.bashrc
	sudo pacman -S zsh git vim dropbox nautilus-dropbox ibus-mozc mozc tmux keychain  \
	gnome-tweak-tool xsel sylpheed emacs curl archlinux-wallpaper evince inkscape gimp unrar \
	file-roller vlc xclip atool trash-cli the_silver_searcher powertop cifs-utils \
	gvfs gvfs-smb seahorse gnome-keyring cups-pdf redshift eog mcomix libreoffice-fresh-ja
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
