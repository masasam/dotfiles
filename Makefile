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
