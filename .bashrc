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
alias tmuxdev='tmuxp load main'
alias urxvtsetup='xrdb -merge $HOME/.Xresources; exit'
export HISTCONTROL=ignoredups
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
PATH="$HOME/.local/bin:$PATH"
export COMPOSER_HOME=${HOME}/src/github.com/masasam/dotfiles
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
if [ -f '/home/masa/bin/google-cloud-sdk/path.bash.inc' ]; then . '/home/masa/bin/google-cloud-sdk/path.bash.inc'; fi
# nvm
source /usr/share/nvm/init-nvm.sh
