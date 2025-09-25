#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTFILE=~/backup/bash/.bash_history
alias ls='ls --color=auto'
alias testemacs='emacs -q -l ~/.emacs.d/test.el'
PS1='[\u@\h \W]\$ '
alias screenstart='screen -D -RR'
alias tmuxstart='tmux new -s main'
alias tmuxdev='tmuxp load main'
alias urxvtsetup='xrdb -merge $HOME/.Xresources; exit'
export HISTCONTROL=ignoredups
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export LIBVA_DRIVER_NAME=iHD
export PAGER=less
export LESS='-g -i -M -R -S -W -z-4 -x4'
