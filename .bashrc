#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias remacs='emacs -q -l ~/Dropbox/emacs/default.el'
PS1='[\u@\h \W]\$ '
alias screenstart='screen -D -RR'
alias tmuxstart='tmux new-session -A -s main'
export HISTCONTROL=ignoredups
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.cask/bin:$PATH"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export WORKON_HOME=~/.virtualenvs
#source $HOME/.local/bin/virtualenvwrapper.sh
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=~/Dropbox/emacs/rustc-1.14.0/src
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
PATH="$HOME/.local/bin:$PATH"
export GTAGSCONF=/usr/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export LESS='-g -i -M -R -S -W -z-4 -x4'
eval "$(direnv hook bash)"
