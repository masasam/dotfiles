#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias screenstart='screen -D -RR'
alias tmuxstart='tmux new-session -A -s main'
export HISTCONTROL=ignoredups

# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.cask/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=~/Dropbox/emacs/rustc-1.14.0/src
export GTAGSCONF=/usr/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export LESS='-g -i -M -R -S -W -z-4 -x4'
