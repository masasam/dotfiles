#!/bin/bash
ln -sf ~/git/dotfiles/.zshrc ~/.zshrc
ln -sf ~/git/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/git/dotfiles/.screenrc ~/.screenrc
ln -sf ~/git/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/git/dotfiles/.xinitrc ~/.xinitrc
ln -sf ~/git/dotfiles/redshift.conf ~/.config/redshift.conf
ln -sfn ~/git/dotfiles/.peco ~/.peco
ln -sfn ~/git/dotfiles/.emacs.d ~/.emacs.d
ln -sfn ~/Dropbox/ssh ~/.ssh
ln -sfn ~/Dropbox/sylpheed/.sylpheed-2.0 ~/.sylpheed-2.0
ln -sfn ~/Dropbox/mozc/.mozc ~/.mozc
chmod 600 ~/.ssh/id_rsa
