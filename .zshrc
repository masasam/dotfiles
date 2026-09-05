# zshrc
fpath=("$HOME/.zfunc" ${fpath})
plugins=(… zsh-completions)
autoload -U compinit promptinit
compinit
promptinit

export LANG=ja_JP.UTF-8
export CODEX_NOTIFY_ONLY_WHEN_UNFOCUSED=0

autoload -Uz colors
colors

# last line (\n) probrem countermeasure
unsetopt promptcr

HISTFILE=~/backup/zsh/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# ask you if you have over 10000 history
LISTMAX=10000

zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}
	[[ ${#line} -ge 5 && ${cmd} != tm && ${cmd} != ll && ${cmd} != ls && ${cmd} != la && ${cmd} != cd && ${cmd} != man && ${cmd} != scp && ${cmd} != ssh && ${cmd} != vim && ${cmd} != nvim && ${cmd} != less && ${cmd} != ping && ${cmd} != open && ${cmd} != file && ${cmd} != which && ${cmd} != whois && ${cmd} != drill && ${cmd} != uname && ${cmd} != md5sum && ${cmd} != pacman && ${cmd} != xdg-open && ${cmd} != traceroute && ${cmd} != speedtest-cli ]]
}

unsetopt extended_history
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_no_store
# Add history
setopt append_history
# Add history incremental
setopt inc_append_history
# Share history other terminal
setopt share_history
# Duplicate command delete it older
setopt hist_ignore_all_dups
# Same command as before don't add to history
setopt hist_ignore_dups
# Commands beginning with a space delete from history list
setopt hist_ignore_space
# While calling history and executing stop editing once
unsetopt hist_verify
# Extra white space packed and recorded
setopt hist_reduce_blanks
# When writing to the history file, ignore the same as the old command.
setopt hist_save_no_dups
# Do not register the history command in the history
setopt hist_no_store
# Automatically expand history on completion
setopt hist_expand
# Complementary completion list displayed
setopt list_packed
unsetopt auto_remove_slash
# Matching directory with expanding file name appending / to the end
setopt mark_dirs
# Identification of the type of file in complementary candidate list
setopt list_types
# When there are multiple completion candidates, list display
unsetopt menu_complete
# When there are multiple completion candidates, list display
setopt auto_list
# Automatically complement parentheses' correspondence etc
setopt auto_param_keys
# If you execute the same command name as the suspended process, resume
setopt auto_resume
# Move by directory only
setopt auto_cd
# Do not emit beep with command input error
setopt no_beep
# Enable brace expansion function
setopt brace_ccl
setopt bsd_echo
setopt complete_in_word
# = Expand COMMAND to the path name of COMMAND
setopt equals
# Enable extended globbing
setopt extended_glob
# (Within shell editor) Disable C-s and C-q
unsetopt flow_control
# Do not use flow control by C-s/C-q
setopt no_flow_control
# Hash the path when each command is executed
setopt hash_cmds
# Do not kill background jobs when logging out
setopt no_hup
# By default, jobs -L is set as the output of the internal command jobs
setopt long_list_jobs
setopt mail_warning
# Interpret numbers as numbers and sort
setopt numeric_glob_sort
# Search for subdirectories in PATH when / is included in command name
setopt path_dirs
# Appropriate display of Japanese in completion candidate list
setopt print_eight_bit
# With command line arguments you can complement even after = = PREFIX = / USR etc
setopt magic_equal_subst
# When completing completion candidates, display as compacted as possible.
setopt list_packed
# Include alias as a candidate for completion.
setopt complete_aliases
# Do not delete the last / when the directory name is an argument
setopt noautoremoveslash
# TEE and CAT functions such as multiple redirects and pipes are used as necessary
setopt multios
# You will be able to use simplified grammar with FOR, REPEAT, SELECT, IF, FUNCTION
setopt short_loops
# Automatically add / at the end with directory name completion to prepare for the next completion
setopt auto_param_slash
# Completion key Completion candidate is complemented automatically in order by repeated hitting
setopt auto_menu

# Completion of sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

zstyle ':completion:*' use-cache true
# Select completion candidate with ← ↓ ↑ →
zstyle ':completion:*:default' menu select=1
# Since there may be uniquely determined files, first complement them
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
# Candidate directories on cdpath only when there is no candidate in the current directory
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# Process name completion of ps command
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
# Color a completion candidate
eval `dircolors -b`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# prompt
PROMPT="%{%(?.$fg_bold[cyan].$fg_bold[red])%}%m%{$fg_bold[white]%}%%%{$reset_color%} "
PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
# Show your current location on the right prompt
RPROMPT="%{$fg_bold[white]%}[%{$reset_color%}%{$fg[cyan]%}%~%{$reset_color%}%{$fg_bold[white]%}]%{$reset_color%}"

# emacs keybind
bindkey -e

# Present candidate for moved directory
setopt auto_pushd

# Do not record duplicate directories with auto_pushd.
setopt pushd_ignore_dups

# It points out the misspelling of the command and presents the expected correct command.
setopt correct

# Permission when creating files
umask 022

# vcs_info
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# Tmux, pass the name of the command currently executed to screen
case "${TERM}"
in screen-256color)
       preexec() {
	   echo -ne "\ek#${1%% *}\e\\"
       }
       precmd() {
	   echo -ne "\ek$(basename $(pwd))\e\\"
	   vcs_info
       };;
   tmux-256color)
       preexec() {
	   echo -ne "\ek#${1%% *}\e\\"
       }
       precmd() {
	   echo -ne "\ek$(basename $(pwd))\e\\"
	   vcs_info
       };;
   xterm)
       preexec() {
	   echo -ne "\ek#${1%% *}\e\\"
       }
       precmd() {
	   echo -ne "\ek$(basename $(pwd))\e\\"
	   vcs_info
       };;
esac

# Delete by word with C-w
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# If command not found then find it when using arch linux(sudo pacman -S pkgfile)
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# keychain config
/usr/bin/keychain -q $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh

# completion mosh
compdef mosh=ssh

# aliases
alias tm='tmux new -s main'
alias ls='ls -v -F --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack #./hogefuga.tar.gz(pacman -S atool)
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
alias du='du -h'
alias df='df -h'
alias free='free -h --si'
alias e='emacsclient'
alias testemacs='emacs -q -l ~/.emacs.d/test.el'
alias open='xdg-open'
alias mysql="mysql --pager='less -S -n -i -F -X'"
alias syncdropbox='time rclone sync ${HOME}/backup dropbox:backup'
alias syncqnap='time rclone sync ${HOME}/backup qnap:backup'
alias backupcloud='syncdropbox; syncqnap'
# alias followupdropbox='time rclone sync dropbox:backup ${HOME}/backup'
# alias followupqnap='time rclone sync qnap:backup ${HOME}/backup'
# alias followupcloud='followupdropbox; followupqnap'
alias zshbackup='rm -rf ${HOME}/backup/zsh/backup/`ls -rt ${HOME}/backup/zsh/backup | head -n 1`; tar cfz ${HOME}/backup/zsh/backup/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/backup/zsh/ .zsh_history'
alias melpabackup='rm -rf ${HOME}/backup/emacs/elpa/`ls -rt ${HOME}/backup/emacs/elpa | head -n 1`; tar cfz ${HOME}/backup/emacs/elpa/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d elpa'
alias melpacleanup='rm -rf ${HOME}/.emacs.d/elpa'
alias dockercleanup='docker system df; docker container prune; docker volume prune; docker image prune; docker network prune; docker system prune -a; docker system df'
alias yaycleanup='yay -Sc --aur'
alias kindstart='kind create cluster; export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"; kubectl cluster-info'
alias kindstop='unset KUBECONFIG; kind delete cluster'
alias mirrorupdate='sudo reflector --latest 20 --age 12 --country JP --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist'
alias archupdate='yay -Syu; paccache -r; paccache -ruk0'
alias archbackup='cd ${HOME}/src/github.com/masasam/dotfiles; make backup; cd -'
alias gcloudupdate='gcloud components update'
alias battery='sudo tlp-stat -b'
alias uefiupdate='fwupdmgr refresh --force; fwupdmgr get-updates; fwupdmgr update'
alias allupdate='time archupdate && time melpabackup && time zshbackup && time archbackup && time backupcloud'
alias md2pdf='dotctl md2pdf'
alias md2docx='dotctl md2docx'
alias optimize-jpg='dotctl optimize-jpg'
alias optimize-png='dotctl optimize-png'
alias blog-jpg='dotctl blog-jpg'
alias rec2gif='dotctl rec2gif'
alias postgres-backup='dotctl postgres-backup'
alias check-iso='dotctl check-iso'
alias dirsum='dotctl dirsum'
alias timer='dotctl timer'

# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.node_modules/bin:$PATH"
unset npm_config_prefix
export PATH="$HOME/.local/bin:$PATH"
export LIBVA_DRIVER_NAME=iHD
export GTAGSCONF=/usr/share/gtags/gtags.conf
export GTAGSLABEL=pygments
export PAGER=less
export LESS='-g -i -M -R -S -W -z-4 -x4'

# cdr
autoload -Uz is-at-least
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*:*:cdr:*:*' menu selection
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-max 5000
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-file "$HOME/backup/zsh/chpwd-recent-dirs"
  zstyle ':chpwd:*' recent-dirs-pushd true
fi

# cd after then ls
function chpwd() {
    ls -v -F --color=auto
}

# Invoke the ``dired'' of current working directory in Emacs buffer.
function dired() {
    emacsclient -e "(dired \"${1:-$PWD}\")" & wmctrl -a emacs
}

# Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function cde() {
    EMACS_CWD=`emacsclient -e "
     (expand-file-name
      (with-current-buffer
          (if (featurep 'elscreen)
              (let* ((frame-confs (elscreen-get-frame-confs (selected-frame)))
                     (num (nth 1 (assoc 'screen-history frame-confs)))
                     (cur-window-conf (cadr (assoc num (assoc 'screen-property frame-confs))))
                     (marker (nth 2 cur-window-conf)))
                (marker-buffer marker))
            (nth 1
                 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration))))))
        default-directory))" | sed 's/^"\(.*\)"$/\1/'`
    echo "chdir to $EMACS_CWD"
    cd "$EMACS_CWD"
}

function history-fzf() {
    BUFFER=$(history -n -r 1 | fzf-tmux -d --reverse --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
}
zle -N history-fzf
bindkey '^r' history-fzf

function cdr-fzf() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf-tmux -d --reverse --prompt="cd > ")
    if [ -n "$selected_dir" ]; then
	BUFFER="cd ${selected_dir}"
	zle accept-line
    fi
    zle clear-screen
}
zle -N cdr-fzf
bindkey '^xf' cdr-fzf
bindkey '^x^f' cdr-fzf

function ghq-fzf() {
  local selected_dir=$(ghq list | fzf-tmux -d --reverse --query="$LBUFFER" --prompt="ghq list > ")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey '^x^l' ghq-fzf
bindkey '^xl' ghq-fzf

function keybind-fzf() {
    zle $(bindkey | fzf-tmux -d --reverse --prompt="Keybind > " | cut -d " " -f 2)
}
zle -N keybind-fzf
bindkey '^xB' keybind-fzf

function fzf-checkout-pull-request () {
    local selected_pr_id=$(gh pr list | fzf-tmux -d --reverse --prompt="pr > " --query "$LBUFFER" | awk '{ print $1 }')
    if [ -n "$selected_pr_id" ]; then
        BUFFER="gh pr checkout ${selected_pr_id}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf-checkout-pull-request
bindkey '^xg' fzf-checkout-pull-request
bindkey '^x^g' fzf-checkout-pull-request

alias ipsort='zshctl ipsort'
alias remove-exif='zshctl remove-exif'
alias gitignore='zshctl gitignore'
alias mytldr='zshctl mytldr'
alias ide='zshctl ide 1'
alias ide2='zshctl ide 2'
alias ide3='zshctl ide 3'
alias ide4='zshctl ide 4'
alias topdf='zshctl topdf'

# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/masa/google-cloud-sdk/path.zsh.inc' ]; then . '/home/masa/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/masa/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/masa/google-cloud-sdk/completion.zsh.inc'; fi

# zsh-completions for aws
autoload bashcompinit
bashcompinit
complete -C 'aws_completer' aws

# pnpm
export PNPM_HOME="/home/masa/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# mise
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# uv
eval "$(uv generate-shell-completion zsh)"

# codex
eval "$(codex completion zsh)"

# Turso
export PATH="$PATH:/home/masa/.turso"
