init:
	ln -vsf `pwd`/.zshrc   ~/.zshrc
	ln -vsf `pwd`/.gitconfig   ~/.gitconfig
	ln -vsf `pwd`/.screenrc   ~/.screenrc
	ln -vsf `pwd`/.tmux.conf   ~/.tmux.conf
	ln -vsf `pwd`/.xinitrc   ~/.xinitrc
	ln -vsf `pwd`/redshift.conf   ~/.config/redshift.conf
	ln -vsfn `pwd`/.peco   ~/.peco
	ln -vsfn `pwd`/.emacs.d   ~/.emacs.d
	ln -vsfn ~/Dropbox/ssh ~/.ssh
	ln -vsfn ~/Dropbox/sylpheed/.sylpheed-2.0 ~/.sylpheed-2.0
	ln -vsfn ~/Dropbox/mozc/.mozc ~/.mozc
	chmod 600 ~/.ssh/id_rsa
	cd ~/.emacs.d/;	cask upgrade;	cask install
update:
	cd ~/.emacs.d/;	cask update
sync:
	git pull
	git push
