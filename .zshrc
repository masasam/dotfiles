# zshrc
plugins=(… zsh-completions)
autoload -U compinit promptinit
compinit
promptinit

export LANG=ja_JP.UTF-8

autoload -Uz colors
colors

unsetopt promptcr # last line (\n) probrem countermeasure

HISTFILE=~/Dropbox/zsh/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
LISTMAX=10000 # ask you if you have over 10000 history

unsetopt extended_history
setopt append_history       # add history
setopt inc_append_history   # add history incremental
setopt share_history        # hare history other terminal
setopt hist_ignore_all_dups # Duplicate command delete it older
setopt hist_ignore_dups     # Same command as before don't add to history
setopt hist_ignore_space    # Commands beginning with a space delete from history list
unsetopt hist_verify        # While calling history and executing stop editing once
setopt hist_reduce_blanks   # Extra white space packed and recorded
setopt hist_save_no_dups    # When writing to the history file,Ignore the same as the old command.
setopt hist_no_store        # Do not register the history command in the history
setopt hist_expand          # Automatically expand history on completion
setopt list_packed          # Complementary completion list displayed
unsetopt auto_remove_slash
setopt mark_dirs       # Matching directory with expanding file name appending / to the end
setopt list_types      # Identification of the type of file in complementary candidate list
unsetopt menu_complete # When there are multiple completion candidates, list display
setopt auto_list       # When there are multiple completion candidates, list display
setopt auto_param_keys # Automatically complement parentheses' correspondence etc
setopt auto_resume     # If you execute the same command name as the suspended process, resume
setopt auto_cd         # Move by directory only
setopt no_beep         # Do not emit beep with command input error
setopt brace_ccl       # Enable brace expansion function
setopt bsd_echo
setopt complete_in_word
setopt equals            # = Expand COMMAND to the path name of COMMAND
setopt extended_glob     # Enable extended globbing
unsetopt flow_control    # (Within shell editor) Disable C-s and C-q
setopt no_flow_control   # Do not use flow control by C-s / C-q
setopt hash_cmds         # Hash the path when each command is executed
setopt no_hup            # Do not kill background jobs when logging out
setopt long_list_jobs    # By default, jobs -L is set as the output of the internal command jobs
setopt mail_warning
setopt numeric_glob_sort # Interpret numbers as numbers and sort
setopt path_dirs         # Search for subdirectories in PATH when / is included in command name
setopt print_eight_bit   # Appropriate display of Japanese in completion candidate list
setopt magic_equal_subst # With command line arguments you can complement even after = = PREFIX = / USR etc
setopt list_packed       # When completing completion candidates, display as compacted as possible.
setopt complete_aliases  # Include alias as a candidate for completion.
setopt noautoremoveslash # Do not delete the last / when the directory name is an argument
setopt multios     # TEE and CAT functions such as multiple redirects and pipes are used as necessary
setopt short_loops # You will be able to use simplified grammar with FOR, REPEAT, SELECT, IF, FUNCTION
setopt auto_param_slash # Automatically add / at the end with directory name completion to prepare for the next completion
setopt auto_menu # Completion key Completion candidate is complemented automatically in order by repeated hitting

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

# prompt
case ${UID} in
    0)
	PROMPT="%{$fg_bold[green]%}%m%{$fg_bold[red]%}#%{$reset_color%} "
	PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
	;;
    *)
	PROMPT="%{$fg_bold[cyan]%}%m%{$fg_bold[white]%}%%%{$reset_color%} "
	PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
	;;
esac

# Show your current location on the right prompt.
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
case "${TERM}" in screen-256color)
		      preexec() {
			  echo -ne "\ek#${1%% *}\e\\"
		      }
		      precmd() {
			  echo -ne "\ek$(basename $(pwd))\e\\"
			  vcs_info
		      }
esac


# Delete by word with C-w
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


# if command not found then find it when using arch linux(sudo pacman -S pkgfile)
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi


# keychain config
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh


# aliases
alias ls='ls -v -F --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack #./hogefuga.tar.gz(pacman -S atool)
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
alias du='du -h'
alias df='df -h'
alias e='emacsclient'
alias open='xdg-open'
alias vim='nvim'
alias mysql="mysql --pager='less -S -n -i -F -X'"
alias sudotramp='emacsclient -a emacs -n /sudo:$(grep -iE "host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias tramp='emacsclient -a emacs -n /ssh:$(grep -iE "host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'
alias caskupdate='rm -rf ${HOME}/Dropbox/emacs/cask/`ls -rt ${HOME}/Dropbox/emacs/cask | head -n 1`;tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask;cd ${HOME}/.emacs.d/;cask upgrade;cask update;cd -'
alias caskinstall='cd ${HOME}/.emacs.d/;cask upgrade;cask install;cd -'
alias goupdate='go get -u all'
alias rust='cargo-script'
alias rustupdate='cargo install-update -a'
alias archupdate='yaourt -Syua; paccache -r'
alias archbackup="mkdir -p ${HOME}/Dropbox/arch;pacman -Qqen > ${HOME}/Dropbox/arch/pacmanlist.txt;pacman -Qnq > ${HOME}/Dropbox/arch/allpacmanlist.txt;pacman -Qqem > ${HOME}/Dropbox/arch/yaourtlist.txt"
alias gpg-import='gpg --allow-secret-key-import --import ~/Dropbox/passwd/privkey.asc;gpg --import ~/Dropbox/passwd/publickey.asc'


# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.cask/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=~/Dropbox/emacs/rustc-1.14.0/src
export PATH=$PATH:/usr/bin/vendor_perl


# Invoke the ``dired'' of current working directory in Emacs buffer.
function dired() {
    emacsclient -e "(dired \"${1:-$PWD}\")" & wmctrl -a emacs
}


## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function cde () {
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


# replace history
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
	tac="tac"
    else
	tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | peco)
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history


# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi


# cd after then ls
function chpwd() {
    ls -v -F --color=auto
}


function peco-cdr() {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
	BUFFER="cd ${selected_dir}"
	zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^xf' peco-cdr
bindkey '^x^f' peco-cdr


function peco-ghq() {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-ghq
bindkey '^x^l' peco-ghq
bindkey '^xl' peco-ghq


# peco-ghq-remote
function peco-ghq-remote() {
    hub browse $(ghq list | peco | cut -d "/" -f 2,3)
}
zle -N peco-ghq-remote
bindkey '^xg' peco-ghq-remote
bindkey '^x^g' peco-ghq-remote


# peco open my booklist
function peco-books() {
  local book="$(find ~/Dropbox/books -type f | peco)"
  if [ -n "$book" ]; then
      open $book
  fi
}
zle -N peco-books
bindkey '^xb' peco-books


# show peco keybinds
function peco-keybinds() {
    zle $(bindkey | peco | cut -d " " -f 2)
}
zle -N peco-keybinds
bindkey '^x^b' peco-keybinds


function peco-godoc() {
    godoc $(ghq list --full-path | peco) | less
}
zle -N peco-godoc
bindkey '^x^v' peco-godoc


function _getgitignore() {
    curl -s https://www.gitignore.io/api/$1
}
alias getgitignore='_getgitignore $(_getgitignore list | sed "s/,/\n/g" | peco )'


# jump git root directory
function gitroot() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
	cd $1
    fi
}


# github create new repository
function github-new-repository() {
    if [ $# = 1 ]; then
	ghq root && cat ~/.config/hub | grep user && cd $(ghq root)/github.com/$(cat ~/.config/hub | grep user | awk '{print $3}') && mkdir $1
	if [ $? = 0 ]; then
	    cd $1
	    git init .
	    hub create
	    touch README.md
	    git add README.md
	    git commit -m 'first commit'
	    git push origin master
	fi
    else
	echo 'arg1 required "repository name"'
    fi
}


# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
