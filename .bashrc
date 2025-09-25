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
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH="$PATH:$HOME/src/github.com/JakeBecker/elixir-ls/rel/"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/src/github.com/flutter/flutter/bin"
export LIBVA_DRIVER_NAME=iHD
export GTAGSCONF=/usr/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export PAGER=less
export LESS='-g -i -M -R -S -W -z-4 -x4'
export RBENV_ROOT="${HOME}/.rbenv"
if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
# The next line updates PATH for the Google Cloud SDK.
if [ -f '${HOME}/google-cloud-sdk/path.bash.inc' ]; then . '${HOME}/google-cloud-sdk/path.bash.inc'; fi
