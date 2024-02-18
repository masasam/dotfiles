# zshrc
fpath=("$HOME/.zfunc" ${fpath})
plugins=(… zsh-completions)
autoload -U compinit promptinit
compinit
promptinit

export LANG=ja_JP.UTF-8

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

    # Only those that satisfy all of the following conditions are added to the history
    [[ ${#line} -ge 5
       && ${cmd} != ll
       && ${cmd} != ls
       && ${cmd} != la
       && ${cmd} != cd
       && ${cmd} != man
       && ${cmd} != scp
       && ${cmd} != ssh
       && ${cmd} != vim
       && ${cmd} != nvim
       && ${cmd} != less
       && ${cmd} != ping
       && ${cmd} != open
       && ${cmd} != file
       && ${cmd} != which
       && ${cmd} != whois
       && ${cmd} != drill
       && ${cmd} != uname
       && ${cmd} != md5sum
       && ${cmd} != pacman
       && ${cmd} != blog-jpg
       && ${cmd} != xdg-open
       && ${cmd} != mpv-music
       && ${cmd} != mpv-video
       && ${cmd} != traceroute
       && ${cmd} != speedtest-cli
    ]]
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
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh

# completion mosh
compdef mosh=ssh


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
alias free='free -h --si'
alias iv='sxiv'
alias is='whois'
alias myip="ip -4 a show wlp0s20f3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias e='emacsclient'
alias testemacs='emacs -q -l ~/.emacs.d/test.el'
alias open='xdg-open'
alias mysql="mysql --pager='less -S -n -i -F -X'"
alias syncdropbox='time rclone sync ${HOME}/backup dropbox:backup'
alias syncdrive='time rclone sync ${HOME}/backup drive:backup'
alias backupcloud='syncdropbox; syncdrive'
alias followupdropbox='time rclone sync dropbox:backup ${HOME}/backup'
alias followupdrive='time rclone sync drive:backup ${HOME}/backup'
alias followupcloud='followupdropbox; followupdrive'
alias zshbackup='rm -rf ${HOME}/backup/zsh/backup/`ls -rt ${HOME}/backup/zsh/backup | head -n 1`; tar cfz ${HOME}/backup/zsh/backup/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/backup/zsh/ .zsh_history'
alias melpabackup='rm -rf ${HOME}/backup/emacs/elpa/`ls -rt ${HOME}/backup/emacs/elpa | head -n 1`; tar cfz ${HOME}/backup/emacs/elpa/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d elpa'
alias melpacleanup='rm -rf ${HOME}/.emacs.d/elpa'
alias dockercleanup='docker system df; docker container prune; docker volume prune; docker image prune; docker network prune; docker system prune -a; docker system df'
alias yaycleanup='yay -Sc --aur'
alias goupdate='cd ${HOME}/src/github.com/masasam/dotfiles; make goinstall; cd -'
alias kindstart='kind create cluster; export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"; kubectl cluster-info'
alias kindstop='unset KUBECONFIG; kind delete cluster'
alias rustupdate='rustup update'
alias cargoupdate='cargo install-update -a'
alias cargocleanup='rm -rf ${HOME}/.cargo/bin/*; cd ${HOME}/src/github.com/masasam/dotfiles; make rustinstall; cd -'
alias yarnupdate='yarn global upgrade'
alias yarncleanupcash='yarn cache clean'
alias pipbackup='cd ${HOME}/src/github.com/masasam/dotfiles; make pipbackup; cd -'
alias pipupdate='pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user'
alias pipcleanup='pip cache purge'
alias archupdate='yay -Syu; paccache -r; paccache -ruk0'
alias archbackup='cd ${HOME}/src/github.com/masasam/dotfiles; make backup; cd -'
alias gcloudupdate='gcloud components update'
alias battery='sudo tlp-stat -b'
alias ibusrestart='ibus-daemon -drx'
alias uefiupdate='fwupdmgr refresh --force; fwupdmgr get-updates; fwupdmgr update'
alias soundrecord='arecord -t wav -f dat -q | lame -b 128 -m s - out.mp3'
alias fontlist='fc-list | cut -d: -f1 | less'
alias fontlistja='fc-list :lang=ja | cut -d: -f1 | less'
alias jupytertheme='jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8'
alias myvpn='cd ~/backup/openvpn; sudo openvpn --config client.conf'
alias allupdate='time archupdate && time melpabackup && time zshbackup && time pipbackup && time archbackup && time backupcloud && time yarnupdate && time goupdate'
alias djangoinit='python manage.py create_required_buckets && python manage.py collectstatic && python manage.py migrate && python manage.py createsuperuser && python manage.py runserver'


# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.node_modules/bin:$PATH"
unset npm_config_prefix
PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
export PATH="$PATH:$HOME/src/github.com/flutter/flutter/bin"
export PATH=$PATH:$HOME/.roswell/bin
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
# export ANDROID_HOME=~/Android/Sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

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


function ghq-delete-fzf() {
    ghq list --full-path | fzf-tmux -d --reverse --prompt="github-delete > " | xargs -r rm -r
}
zle -N ghq-delete-fzf
bindkey '^xD' ghq-delete-fzf


function ghs-import-fzf() {
    [ "$#" -eq 0 ] && echo "Usage : ghs-import QUERY" && return 1
    ghs "$@" | fzf-tmux -d --reverse | awk '{print $1}' | ghq import
}


function github-issue-fzf() {
    hub issue | fzf-tmux -d --reverse --prompt="github issue > " | \
	sed -e "s/\].*//" | xargs -Inum git checkout -b feature/num
}
zle -N github-issue-fzf
bindkey '^x^i' github-issue-fzf


function git-branch-fzf() {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
				perl -pne 's{^refs/heads/}{}' | \
				fzf-tmux -d --reverse --query "$LBUFFER" --prompt="git branch > ")
  if [ -n "$selected_branch" ]; then
    BUFFER="git checkout ${selected_branch}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N git-branch-fzf
bindkey "^x^b" git-branch-fzf
bindkey "^xb" git-branch-fzf


function git-hash-fzf() {
    local current_buffer=$BUFFER
    local git_hash="$(git log --oneline --branches | fzf-tmux -d --reverse --prompt="git hash > " | awk '{print $1}')"
    BUFFER="${current_buffer}${git_hash}"
    CURSOR=$#BUFFER
}
zle -N git-hash-fzf
bindkey '^x^h' git-hash-fzf


function git-stash-fzf() {
    local current_buffer=$BUFFER
    local stash="$(git stash list | fzf-tmux -d --reverse --prompt="git stash > " | awk -F'[ :]' '{print $1}')"
    BUFFER="${current_buffer}${stash}"
    CURSOR=$#BUFFER
}
zle -N git-stash-fzf
bindkey '^x^s' git-stash-fzf


function ps-fzf() {
    local current_buffer=$BUFFER
    local process_id="$(ps auxf | fzf-tmux -d --reverse --prompt="ps > " | awk '{print $2}')"
    BUFFER="${current_buffer}${process_id}"
    CURSOR=$#BUFFER
}
zle -N ps-fzf
bindkey '^xp' ps-fzf
bindkey '^x^p' ps-fzf


function alias-fzf() {
    BUFFER=$(alias | fzf-tmux -d --reverse --query "$LBUFFER" --prompt="Alias > " | awk -F"=" '{print $1}')
    print -z "$BUFFER"
}


function keybind-fzf() {
    zle $(bindkey | fzf-tmux -d --reverse --prompt="Keybind > " | cut -d " " -f 2)
}
zle -N keybind-fzf
bindkey '^xB' keybind-fzf


function ansible-fzf() {
    local repositoryname='ansible-setup-server'
    ghq root && cat ~/.config/hub | grep user && \
	cd $(ghq root)/github.com/$(cat ~/.config/hub | grep user | awk '{print $3}')/${repositoryname}
    if [ $? = 0 ]; then
	local selected_yml=$(ls | grep .yml$ | fzf-tmux -d --reverse --prompt="Ansible > ")
	if [ -n "$selected_yml" ]; then
	    ansible-playbook --ask-vault-pass ${selected_yml}
	    if [ $? = 0 ]; then
		notify-send -u critical 'Ansible' 'Your playbook execution ended' -i utilities-terminal
	    else
		notify-send -u critical 'Ansible' 'Error has occured' -i dialog-error
	    fi
	fi
	cd -
    fi
}
zle -N ansible-fzf
bindkey '^x^a' ansible-fzf


function weather-fzf() {
    curl wttr.in/$(echo -e "Sapporo\nSendai\nTokyo\nYokohama\nKawasaki\nNagano\nNagoya\nKanazawa\nKyoto\nOsaka-shi\nKobe\nOkayama-Shi\nHiroshima-Shi\nTakamatsu\nMatsuyama\nHakata" | fzf-tmux -d --reverse --prompt="Weather > ") | less -R
}


function gitlog-fzf() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
  fzf-tmux -d --prompt="git log > " --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}


function ssh-fzf () {
    local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf-tmux -d --reverse --prompt="ssh > " --query "$LBUFFER")

    if [ -n "$selected_host" ]; then
	BUFFER="ssh ${selected_host}"
	zle accept-line
    fi
    zle reset-prompt
}
zle -N ssh-fzf
bindkey '^\' ssh-fzf


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


function rails-routes-fzf() {
    BUFFER=$(bin/rails routes | fzf-tmux -d --reverse --no-sort +m --query "$LBUFFER" --prompt="rails routes > ")
    CURSOR=$#BUFFER
}


function gitroot() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
	cd $1
    fi
}


function github-new() {
    if [ $# = 1 ]; then
	ghq root && cat ~/.config/hub | grep user \
	    && cd $(ghq root)/github.com/$(cat ~/.config/hub \
					       | grep user | awk '{print $3}') && mkdir $1
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
	echo 'usage: github-new reponame'
    fi
}


function ipsort() {
    if [ $# = 1 ]; then
	cat $1 | sort -n -t'.' -k1,1 -k2,2 -k3,3 -k4,4
    else
	echo 'usage: ipsort iplist'
    fi
}


function webm2gif() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	ffmpeg -i $1 -pix_fmt rgb24 $fname.gif
    else
	echo 'usage: webm2gif file.webm'
    fi
}


function md2pdf() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	pandoc $1 -o $fname.pdf -V mainfont=IPAPGothic -V fontsize=16pt --pdf-engine=lualatex
    else
	echo 'usage: md2pdf file.md'
    fi
}


function md2docx() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	pandoc $1 -t docx -o $fname.docx -V mainfont=IPAPGothic -V fontsize=16pt --toc --highlight-style=zenburn
    else
	echo 'usage: md2docx file.md'
    fi
}


function remove-exif() {
    if [ $# = 1 ]; then
	jhead -purejpg $1
    else
	echo 'usage: remove-exif file.jpg'
    fi
}


function git-upstream() {
    if [ $# = 1 ]; then
	git remote add upstream $1
    else
	echo 'usage: git-upstream git://github.com/owner/repo.git'
    fi
}


function git-upstream-follow() {
    if [ $# = 1 ]; then
	git remote add upstream $1
	git fetch upstream
	git merge upstream/master
    else
	echo 'usage: git-upstream-follow git://github.com/owner/repo.git'
    fi
}


function gitignore() {
    if [ $# = 2 ]; then
	curl -L -s https://www.gitignore.io/api/$@ > $2
    else
	echo 'usage: gitignore django output'
    fi
}


function github-stars() {
    if [ $# = 2 ]; then
	open "https://github.com/search?q=language%3A$1+stars%3A%3E%3D$2&type=Repositories&ref=searchresults"
    else
	echo 'usage: github-stars language stars'
    fi
}


function terminal-size() {
    echo "width"
    tput cols
    echo "height"
    tput lines
}


function optimize-jpg() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	convert $1 -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB ${fname}_converted.jpg
    else
	echo 'usage: optimize-jpg sample.jpg'
    fi
}


function blog-jpg() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	convert $1 -resize 600x zzz_${fname}.jpg
	rm -rf $1
    else
	echo 'usage: blog-jpg sample.jpg'
    fi
}


function optimize-png() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	convert $1 -strip ${fname}_converted.png
    else
	echo 'usage: optimize-png sample.png'
    fi
}


function clip-file() {
    if [ $# = 1 ]; then
	cat $1 | xsel -bi
    else
	echo 'usage: clip-file file'
    fi
}


function screenshot-window-delay() {
    if [ $# = 1 ]; then
	gnome-screenshot --window --delay=$1
	notify-send 'Screenshot' 'Done' -i camera-photo
    else
	echo 'usage: screenshot-window-delay 5'
    fi
}


function mytldr() {
    if [ $# = 1 ]; then
	unbuffer tldr $1 | less -SR
    else
	echo 'usage: mytldr $1'
    fi
}


function fetch-pull-request() {
    echo "Please input pull request number"
    read NUM
    echo "Please input branch"
    read BRANCH
    git fetch origin pull/${NUM}/head:${BRANCH}
}


function mpv-music() {
    local PLAYLISTDIR=~/backup/youtube
    if [ $# = 0 ]; then
	mpv --no-video --ytdl-format="worstvideo+bestaudio" --quiet --shuffle \
	    --playlist=$(ls $PLAYLISTDIR/*.m3u | fzf-tmux -d --reverse --no-sort +m --prompt="Playlist > ") &	
	sleep 10
	cd -
    elif [ $# = 1 ]; then
	mpv --no-video --ytdl-format="worstvideo+bestaudio" --quiet $1 &
	sleep 10
	cd -
    else
	echo 'usage: mpv-music [youtube-url]'
    fi
}


function mpv-video() {
    local PLAYLISTDIR=~/backup/youtube
    if [ $# = 0 ]; then
	mpv --ontop=yes --border=no --autofit=600 --geometry=100%:100% --ytdl-format="[height<=480]+bestaudio" --quiet \
	    --shuffle --playlist=$(ls $PLAYLISTDIR/*.m3u | fzf-tmux -d --reverse --no-sort +m --prompt="Playlist > ") &
	sleep 10
	cd -
    elif [ $# = 1 ]; then
	mpv --ontop=yes --border=no --autofit=600 --geometry=100%:100% --ytdl-format="[height<=480]+bestaudio" --quiet=yes $1 &
	sleep 10
	cd -
    else
	echo 'usage: mpv-video [youtube-url]'
    fi
}


function mpv-quit() {
    pkill -SIGUSR1 -f mpv
}


function postgres-backup() {
    if [ $# = 1 ]; then
	pg_dump $1 > ~/backup/postgresql/`date '+%Y%m%d%H%M%S'`
    else
	echo 'usage: postgres-backup [dbname]'
    fi
}


function stern-completion-start() {
    if [ $# = 0 ]; then
	source <(stern --completion=zsh)
    else
	echo 'usage: stern-completion-start'
    fi
}


function ide() {
    tmux split-window -v
    tmux split-window -h
    tmux resize-pane -U 7
    tmux select-pane -t 1
}


function ide2() {
    tmux split-window -h
    tmux split-window -v
    tmux select-pane -t 1
}


function ide3() {
    tmux split-window -h
    tmux select-pane -t 1
    tmux split-window -v
    tmux select-pane -t 1
}


function ide4() {
    tmux split-window -h
    tmux split-window -v
    tmux select-pane -t 1
    tmux split-window -v
    tmux select-pane -t 1
}


function aws-profile-change() {
    if [ $# = 1 ]; then
	export AWS_PROFILE=$1
    else
	echo 'Please select a profile from below'
	echo '---------------------'
	aws configure list-profiles
	echo '---------------------'
	echo 'usage: aws-profile-change [profilename]'
    fi
}


function aws-profile-add() {
    if [ $# = 1 ]; then
	aws configure --profile $1
    else
	echo 'Please specify something other than the list below'
	echo '---------------------'
	aws configure list-profiles
	echo '---------------------'
	echo 'usage: aws-profile-add [profilename]'
    fi
}


function check-iso() {
    if [ $# = 2 ]; then
	local archsum=`b2sum $1 | awk '{print $1}'`
	if [ $archsum = $2 ]; then
	    echo 'Correct iso file'
	else
	    echo 'Incorrect iso file'
	fi
    else
	echo 'usage: check-iso [arch.iso] [b2sum]'
    fi
}


function s3-download() {
    if [ $# = 1 ]; then
	open https://s3.console.aws.amazon.com/s3/object/$1	
    else
	echo 'usage: s3-download [s3object]'
    fi
}


function yarncleanup() {
    yarn global remove $(yarn global list | grep info | sed 's/^info "\(.*\)@.*".*$/\1/')
}


function dirsum() {
    if [ $# = 1 ]; then
	find $1 -type f -print0 | xargs -0 shasum | awk '{print $1}' | sort | shasum
    else
	echo 'usage: dirsum [directory]'
    fi	
}

# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-completions for aws
# source ~/.local/bin/aws_zsh_completer.sh
# password
source ~/backup/zsh/env.sh

# nvm
source /usr/share/nvm/init-nvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/masa/google-cloud-sdk/path.zsh.inc' ]; then . '/home/masa/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/masa/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/masa/google-cloud-sdk/completion.zsh.inc'; fi

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip
# pip zsh completion end

# zsh-completions for aws v2
autoload bashcompinit
bashcompinit
complete -C '/usr/local/bin/aws_completer' aws
