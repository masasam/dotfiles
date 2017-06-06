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

zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # Only those that satisfy all of the following conditions are added to the history
    [[ ${#line} -ge 5
       && ${cmd} != ll
       && ${cmd} != ls
       && ${cmd} != la
       && ${cmd} != cd
       && ${cmd} != man
    ]]
}

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
# Color a completion candidate
eval `dircolors -b`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# prompt
case ${UID} in
    0)
	PROMPT="%{$fg_bold[green]%}%m%{$fg_bold[red]%}#%{$reset_color%} "
	PROMPT2="%{$fg[magenta]%}%_%{$reset_color%}%{$fg_bold[white]%}>>%{$reset_color%} "
	;;
    *)
	PROMPT="%{%(?.$fg_bold[cyan].$fg_bold[red])%}%m%{$fg_bold[white]%}%%%{$reset_color%} "
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
alias free='free -h'
alias e='emacsclient'
alias open='xdg-open'
alias vim='nvim'
alias mysql="mysql --pager='less -S -n -i -F -X'"
alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'
alias caskcleanup='rm -rf ${HOME}/.emacs.d/.cask; caskinstall'
alias caskupdate='rm -rf ${HOME}/Dropbox/emacs/cask/`ls -rt ${HOME}/Dropbox/emacs/cask | head -n 1`;tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask;cd ${HOME}/.emacs.d/;cask upgrade;cask update;cd -'
alias caskinstall='cd ${HOME}/.emacs.d/;cask upgrade;cask install;cd -'
alias goupdate='go get -u github.com/nsf/gocode;go get -u github.com/rogpeppe/godef;go get -u golang.org/x/tools/cmd/goimports;go get -u golang.org/x/tools/cmd/godoc;go get -u github.com/josharian/impl;go get -u github.com/jstemmer/gotags'
alias rust='cargo-script'
alias rustupdate='cargo install-update -a'
alias archupdate='yaourt -Syua; paccache -r'
alias archbackup='cd ${HOME}/src/github.com/masasam/dotfiles;make backup;cd -'
alias githubissue='hub issue | peco | sed -e "s/\].*//" | xargs -Inum git checkout -b feature/num'
alias soundrecord='arecord -t wav -f dat -q | lame -b 128 -m s - out.mp3'


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


function github-upstream() {
    git remote add upstream git://github.com/$1
}


function gitlab-upstream() {
    git remote add upstream git://gitlab.com/$1
}


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


function peco-rg() {
    exec rg --vimgrep "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less'
}
zle -N peco-rg
bindkey '^x^g' peco-rg
bindkey '^xg' peco-rg


function peco-ag() {
    exec ag "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less'
}
zle -N peco-ag
bindkey '^x^G' peco-ag
bindkey '^xG' peco-ag


function peco-ack() {
    exec ack "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less '
}
zle -N peco-ack
bindkey '^x^k' peco-ack
bindkey '^xk' peco-ack


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
    add-zsh-hook chpwd my_compact_chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-file "$HOME/Dropbox/zsh/chpwd-recent-dirs"
    zstyle ':chpwd:*' recent-dirs-pushd true
    function my_compact_chpwd_recent_dirs() {
	emulate -L zsh
	setopt extendedglob
	local -aU reply
	integer history_size
	autoload -Uz chpwd_recent_filehandler
	chpwd_recent_filehandler
	history_size=$#reply
	reply=(${^reply}(N))
	(( $history_size == $#reply )) || chpwd_recent_filehandler $reply
    }
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
bindkey '^xr' peco-ghq-remote


function peco-git-branch() {
    local current_buffer=$BUFFER
    local selected_branch_name="$(git branch -a | peco | tr -d ' ' | tr -d '*')"
    case "$selected_branch_name" in
	*-\>* )
	    selected_branch_name="$(echo ${selected_branch_name} | perl -ne 's/^.*->(.*?)\/(.*)$/\2/;print')";;
	remotes* )
	    selected_branch_name="$(echo ${selected_branch_name} | perl -ne 's/^.*?remotes\/(.*?)\/(.*)$/\2/;print')";;
    esac
    if [ -n "$selected_branch_name" ]; then
	BUFFER="${current_buffer}${selected_branch_name}"
	# Move cursor to the end
	CURSOR=$#BUFFER
    fi
}
zle -N peco-git-branch
bindkey '^xb' peco-git-branch
bindkey '^x^b' peco-git-branch


function peco-git-hash() {
    local current_buffer=$BUFFER
    local git_hash="$(git log --oneline --branches | peco | awk '{print $1}')"
    BUFFER="${current_buffer}${git_hash}"
    # Move cursor to the end
    CURSOR=$#BUFFER
}
zle -N peco-git-hash
bindkey '^x^h' peco-git-hash


function peco-git-stash() {
    local current_buffer=$BUFFER
    local stash="$(git stash list | peco | awk -F'[ :]' '{print $1}')"
    BUFFER="${current_buffer}${stash}"
    # Move cursor to the end
    CURSOR=$#BUFFER
}
zle -N peco-git-stash
bindkey '^x^s' peco-git-stash


function peco-ps() {
    local current_buffer=$BUFFER
    local process_id="$(ps auxf | peco | awk '{print $2}')"
    BUFFER="${current_buffer}${process_id}"
    # Move cursor to the end
    CURSOR=$#BUFFER
}
zle -N peco-ps
bindkey '^xp' peco-ps
bindkey '^x^p' peco-ps


function aliasp() {
    BUFFER=$(alias | peco --query "$LBUFFER" | awk -F"=" '{print $1}')
    print -z "$BUFFER"
}


# show peco keybinds
function peco-keybinds() {
    zle $(bindkey | peco | cut -d " " -f 2)
}
zle -N peco-keybinds
bindkey '^xB' peco-keybinds


function peco-godoc() {
    godoc $(ghq list --full-path | peco) | less
}


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
	echo 'One argument is required For example, "github-new-repository newreponame"'
    fi
}


function peco-ansible() {
    local repositoryname='ansible-setup-server'
    ghq root && cat ~/.config/hub | grep user && cd $(ghq root)/github.com/$(cat ~/.config/hub | grep user | awk '{print $3}')/${repositoryname}
    if [ $? = 0 ]; then
	local selected_yml=$(ls | grep .yml$ | peco)
	if [ -n "$selected_yml" ]; then
	    ansible-playbook ${selected_yml}
	    if [ $? = 0 ]; then
		notify-send -u critical 'Ansible' 'Your playbook execution ended' -i utilities-terminal
	    else
		notify-send -u critical 'Ansible' 'Error has occured' -i dialog-error
	    fi
	fi
	cd -
    fi
}
zle -N peco-ansible
bindkey '^x^a' peco-ansible


function peco-weather() {
    curl wttr.in/$(echo -e "Sapporo\nSendai\nTokyo\nYokohama\nKawasaki\nNagano\nNagoya\nKanazawa\nKyoto\nOsaka\nKobe\nOkayama-Shi\nHiroshima-Shi\nTakamatsu\nMatsuyama\nHakata" | peco) | less -R
}


function peco-chrome-bookmark() {
    xdg-open $(cat ~/Dropbox/zsh/bookmark | peco | awk '{print $1}')
}


function peco-search() {
    if [ $# = 0 ]; then
	echo 'One argument is required For example, "peco-seaech pen pineapple apple pen"'
    else
	local search=$(echo -e "google\namazon\nqiita\nhatena\ngithub\ntwitter\nrakuten" | peco)
	if [ $search = 'google' ]; then
	    google "${@}"
	elif [ $search = 'amazon' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "https://www.amazon.co.jp/s/ref=nb_sb_noss?__mk_ja_JP=カタカナ&url=search-alias%3Daps&field-keywords=${query}"
	elif [ $search = 'qiita' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "http://qiita.com/search?q=${query}"
	elif [ $search = 'hatena' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "http://b.hatena.ne.jp/search/text?q=$query"
	elif [ $search = 'github' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "https://github.com/search?utf8=%E2%9C%93&q=$query"
	elif [ $search = 'twitter' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "https://twitter.com/search?q=$query&src=typd"
	elif [ $search = 'rakuten' ]; then
	    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
	    xdg-open "http://search.rakuten.co.jp/search/mall/$query/"
	fi
    fi
}


function google() {
    local query=$(echo "${@}" | sed -e 's/<space>/+/g')
    xdg-open "http://www.google.co.jp/search?q=${query}"
}


function ipsort() {
    cat $1 | sort -n -t'.' -k1,1 -k2,2 -k3,3 -k4,4
}


function webm2gif() {
    ffmpeg -an -i $1 $2
}


# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-completions for google-cloud-sdk(yaourt google-cloud-sdk)
source /opt/google-cloud-sdk/completion.zsh.inc
# zsh-completions for aws(pacman -S aws-cli)
source /usr/bin/aws_zsh_completer.sh
