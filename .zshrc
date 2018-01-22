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
       && ${cmd} != scp
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
       && ${cmd} != mytimer
       && ${cmd} != traceroute
       && ${cmd} != speedtest-cli
    ]]
}

unsetopt extended_history
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt append_history       # Add history
setopt inc_append_history   # Add history incremental
setopt share_history        # Share history other terminal
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

# # prompt
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
alias free='free -h'
alias e='emacsclient'
alias remacs='emacs -q -l ~/Dropbox/emacs/default.el'
alias open='xdg-open'
alias mysql="mysql --pager='less -S -n -i -F -X'"
alias caskupdate='rm -rf ${HOME}/Dropbox/emacs/cask/`ls -rt ${HOME}/Dropbox/emacs/cask | head -n 1`; tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask; cd ${HOME}/.emacs.d/; cask upgrade; cask update; cd -'
alias caskinstall='cd ${HOME}/.emacs.d/; cask upgrade; cask install; cd -'
alias caskcleanup='rm -rf ${HOME}/.emacs.d/.cask; caskinstall'
alias goupdate='cd ${HOME}/src/github.com/masasam/dotfiles; make goinstall; cd -'
alias cargoupdate='cargo install-update -a'
alias yarnupdate='yarn global upgrade'
alias pipbackup='cd ${HOME}/src/github.com/masasam/dotfiles; make pipbackup; cd -'
alias pipupdate='cd ${HOME}/src/github.com/masasam/dotfiles; make pipupdate; cd -'
alias pipcheck='pip-review --user'
alias makeinit='cd ${HOME}/src/github.com/masasam/dotfiles; make init; cd -'
alias archupdate='yaourt -Syua; paccache -ruk0'
alias archbackup='cd ${HOME}/src/github.com/masasam/dotfiles; make backup; cd -'
alias soundrecord='arecord -t wav -f dat -q | lame -b 128 -m s - out.mp3'
alias rust='cargo-script'
alias fontlist='fc-list | cut -d: -f1 | less'
alias fontlistja='fc-list :lang=ja | cut -d: -f1 | less'
alias jupytertheme='jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8'
alias gitmaster='git branch --set-upstream-to origin/master master'
alias gitdevelop='git branch --set-upstream-to origin/develop master'
alias rails='bin/rails'


# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$HOME/.cask/bin:$PATH"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
PATH="$HOME/.local/bin:$PATH"
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
  zstyle ':chpwd:*' recent-dirs-file "$HOME/Dropbox/zsh/chpwd-recent-dirs"
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


function select-history() {
  BUFFER=$(history -n -r 1 | fzf-tmux -d --reverse --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history


function rails-routes() {
  BUFFER=$(bin/rails routes | fzf-tmux -d --reverse --no-sort +m --query "$LBUFFER" --prompt="rails routes > ")
  CURSOR=$#BUFFER
}


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


function ghq-delete () {
  ghq list --full-path | fzf-tmux -d --reverse --prompt="github-delete > " | xargs -r rm -r
}
zle -N ghq-delete
bindkey '^xD' ghq-delete


function ghs-import () {
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
zle -N ansible-fzf
bindkey '^x^a' ansible-fzf


function weather-fzf() {
    curl wttr.in/$(echo -e "Sapporo\nSendai\nTokyo\nYokohama\nKawasaki\nNagano\nNagoya\nKanazawa\nKyoto\nOsaka\nKobe\nOkayama-Shi\nHiroshima-Shi\nTakamatsu\nMatsuyama\nHakata" | fzf-tmux -d --reverse --prompt="Weather > ") | less -R
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
	echo 'usage: github-new name'
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
	pandoc $1 -o $fname.pdf -V documentclass=ltjarticle --pdf-engine=lualatex
    else
	echo 'usage: md2pdf file.md'
    fi
}


function md2docx() {
    if [ $# = 1 ]; then
	fname_ext=$1
	fname="${fname_ext%.*}"
	pandoc $1 -t docx -o $fname.docx --toc --highlight-style=zenburn
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


function mytimer() {
    if [ $# = 1 ]; then
	_mytimer $1 &
    else
	echo 'usage: mytimer minute'
    fi
}
function _mytimer() {
    NUM=`expr 60 \* $1`
    sleep $NUM
    notify-send -u critical 'Terminal' 'It is time' -i utilities-terminal
}


function github-upstream() {
    if [ $# = 1 ]; then
	git remote add upstream git://github.com/$1
    else
	echo 'usage: github-upstream name'
    fi
}


function gitlab-upstream() {
    if [ $# = 1 ]; then
	git remote add upstream git://gitlab.com/$1
    else
	echo 'usage: gitlab-upstream name'
    fi
}


function gitignore() {
    curl -L -s https://www.gitignore.io/api/$@
}


function github-stars() {
    if [ $# = 2 ]; then
	open "https://github.com/search?q=language%3A$1+stars%3A%3E%3D$2&type=Repositories&ref=searchresults"
    else
	echo 'usage: githab-stars language stars'
    fi
}


function terminal-size() {
    echo "width"
    tput cols
    echo "height"
    tput lines
}


# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-completions for google-cloud-sdk(yaourt google-cloud-sdk)
source /opt/google-cloud-sdk/completion.zsh.inc
# zsh-completions for aws
source ~/.local/bin/aws_zsh_completer.sh
