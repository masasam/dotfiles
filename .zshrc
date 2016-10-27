# zshrc
plugins=(… zsh-completions)
autoload -U compinit promptinit
compinit
promptinit


# 色の指定を%{$fg[red]%}みたいに人に優しい指定の仕方が出来、コピペもしやすい。リセットするときは%{$reset_color%}。
autoload -Uz colors
colors


# プロンプトに$HOSTとか$UIDとかいった類のものが使用出来るようになる。
setopt prompt_subst

# 改行コード (\n) で終わっていない出力のとき最終行がでないのを防ぐ
unsetopt promptcr



HISTFILE=~/Dropbox/zsh/.zsh_histfile #コマンド履歴はDropboxに
HISTSIZE=1000000
SAVEHIST=1000000
#10000 個以上の補完候補が存在するときに尋ねるようになります
LISTMAX=10000
   # * LISTMAX=-1 →黙って表示(どんなに多くても)
   # * LISTMAX=0 →ウィンドウから溢れるときは尋ねる。
unsetopt extended_history
setopt append_history        # 履歴を追加 (毎回 .zhistory を作るのではなく)
setopt inc_append_history    # 履歴をインクリメンタルに追加
setopt share_history         # 履歴の共有
setopt hist_ignore_all_dups  # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups      # 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_space     # スペースで始まるコマンド行はヒストリリストから削除
unsetopt hist_verify         # ヒストリを呼び出してから実行する間に一旦編集可能を止める
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_save_no_dups     # ヒストリファイルに書き出すときに、古いコマンドと同じものは無視する。
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_expand           # 補完時にヒストリを自動的に展開


# 補完
setopt list_packed           # コンパクトに補完リストを表示
unsetopt auto_remove_slash
setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
unsetopt menu_complete       # 補完の際に、可能なリストを表示してビープを鳴らすのではなく、
setopt auto_list             # ^Iで補完可能な一覧を表示する(補完候補が複数ある時に、一覧表示)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt auto_resume           # サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_cd               # ディレクトリのみで移動
setopt no_beep               # コマンド入力エラーでBeepを鳴らさない
setopt brace_ccl             # ブレース展開機能を有効にする
setopt bsd_echo
setopt complete_in_word
setopt equals                # =COMMAND を COMMAND のパス名に展開
setopt extended_glob         # 拡張グロブを有効にする
unsetopt flow_control        # (shell editor 内で) C-s, C-q を無効にする
setopt no_flow_control       # C-s/C-q によるフロー制御を使わない
setopt hash_cmds             # 各コマンドが実行されるときにパスをハッシュに入れる
setopt no_hup                # ログアウト時にバックグラウンドジョブをkillしない
setopt long_list_jobs        # 内部コマンド jobs の出力をデフォルトで jobs -L にする
setopt magic_equal_subst     # コマンドラインの引数で --PREFIX=/USR などの = 以降でも補完できる
setopt mail_warning
setopt multios               # 複数のリダイレクトやパイプなど、必要に応じて TEE や CAT の機能が使われる
setopt numeric_glob_sort     # 数字を数値と解釈してソートする
setopt path_dirs             # コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt print_eight_bit       # 補完候補リストの日本語を適正表示
setopt short_loops           # FOR, REPEAT, SELECT, IF, FUNCTION などで簡略文法が使えるようになる

# 補完候補を表示するときに出来るだけ詰めて表示。
setopt list_packed
# aliasを補完候補に含める。
setopt complete_aliases
#ディレクトリ名が引数のときに最後の / を削除しない
setopt noautoremoveslash

# sudoの補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 一部のコマンドライン定義は、展開時に時間のかかる処理を行う -- apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perlの-Mオプション, bogofilter (zsh 4.2.1以降), fink, mac_apps (MacOS X)(zsh 4.2.2以降)
zstyle ':completion:*' use-cache true
# 補完候補を ←↓↑→ で選択 (補完候補が色分け表示される)
zstyle ':completion:*:default' menu select=1
# 一意に決まるファイルがあるかもしれないから，まずそのまま補完する
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


# プロンプト
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

# 右プロンプトに現在地を表示。これのおかげで入力位置がウロウロしない。
RPROMPT="%{$fg_bold[white]%}[%{$reset_color%}%{$fg[cyan]%}%~%{$reset_color%}%{$fg_bold[white]%}]%{$reset_color%}"

# emacsキーバインド
bindkey -e

# 移動した場所を記録し、cd -[TAB] で以前移動したディレクトリの候補を提示してくれて、その番号を入力することで移動出来るようになる。
setopt auto_pushd

# auto_pushdで重複するディレクトリは記録しないようにする。
setopt pushd_ignore_dups

# コマンドのスペルミスを指摘して予想される正しいコマンドを提示してくれる。このときのプロンプトがSPROMPT。
setopt correct

# ファイル作成時のパーミッション
umask 022


# LS_COLORS
# 'dircolors -p'で出力されるものに手を加えて保存したものを読み込んでる。
if [ -f ~/.dir_colors ]; then
  eval `dircolors -b ~/.dir_colors`
fi
# 補完候補もLS_COLORSに合わせて色づけ。
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


# vcs_info
RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
# precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'


# screenに現在実行したコマンド名を渡す
case "${TERM}" in screen-256color)
    preexec() {
        echo -ne "\ek#${1%% *}\e\\"
    }
    precmd() {
        echo -ne "\ek$(basename $(pwd))\e\\"
	vcs_info
    }
esac



# ls /usr/local/etc などと打っている際に、C-w で単語ごとに削除
# default  : ls /usr/local → ls /usr/ → ls /usr → ls /
# この設定 : ls /usr/local → ls /usr/ → ls /
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'


# Arch linux でコマンドがないとき誘導 sudo pacman -S pkgfile
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi


# keychainの設定
/usr/bin/keychain $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh


# aliases
alias ls='ls -v -F --color=auto'
alias ll='ls -al'
alias la='ls -A'
# ./hogefuga.tar.gz で解凍できる pacman -S atool
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack
alias cp="cp -ip"
alias mv="mv -i"
alias rm="rm -i"
alias locate="locate -i"
alias lv="lv -c -T8192"
alias du="du -h"
alias df="df -h"
alias open="gnome-open"
alias screen='screen -D -RR'
alias -g C='| xsel --input --clipboard'
alias sudotramp='emacsclient -a emacs -n /sudo:$(grep -iE "^[[:space:]]host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias tramp='emacsclient -a emacs -n /ssh:$(grep -iE "^[[:space:]]host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'
alias caskupdate="cp -R ${HOME}/.emacs.d/.cask /tmp/`date '+%Y%m%d%H%M%S'`;
cd ${HOME}/.emacs.d/;   cask upgrade;   cask update;   cd -"
alias caskinstall='cd ${HOME}/.emacs.d/;   cask upgrade;   cask install;   cd -'


# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.cask/bin"
export EDITOR="emacsclient"
alias e='emacsclient'


# Invoke the ``dired'' of current working directory in Emacs buffer.
function dired () {
  emacsclient -e "(dired \"$PWD\")" & wmctrl -a emacs
}


# Chdir to the ``default-directory'' of currently opened in Emacs buffer.
function cde () {
    EMACS_CWD=`emacsclient -e "
     (expand-file-name
      (with-current-buffer
          (nth 1
               (assoc 'buffer-list
                      (nth 1 (nth 1 (current-frame-configuration)))))
        default-directory))" | sed 's/^"\(.*\)"$/\1/'`

    echo "chdir to $EMACS_CWD"
    cd "$EMACS_CWD"
}


# pecoでC-rのヒストリ検索を置き換え
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


function peco-cdr () {
	local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
	if [ -n "$selected_dir" ]; then
		BUFFER="cd ${selected_dir}"
		zle accept-line
	fi
	zle clear-screen
}
zle -N peco-cdr
bindkey '^xr' peco-cdr


# peco find directory
function peco-find() {
  local current_buffer=$BUFFER
  local search_root=""
  local file_path=""

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    search_root=`git rev-parse --show-toplevel`
  else
    search_root=`pwd`
  fi
  file_path="$(find ${search_root} -maxdepth 5 -a \! -regex '.*/\..*' | peco)"
  BUFFER="${current_buffer} ${file_path}"
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-find
bindkey '^x^f' peco-find


function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src


function emacsag () {
  emacsclient -n $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "+" $2 " " $1}')
}


function _getgitignore() { curl -s https://www.gitignore.io/api/$1 ;}
alias getgitignore='_getgitignore $(_getgitignore list | sed "s/,/\n/g" | peco )'


function blogpost () { cd ~/git/blog; hugo new post/$1.md --editor=emacsclient; cd - }

function imgpost () { cd ~/git/image/image; git add .; git commit -m 'add pic'; git push; cd - }

function publish () { cd ~/git/blog; hugo; rsync -av --delete ~/git/blog/public/ blogdomain:/home/blog/; cd - }


# cdしたらls
function chpwd() { ls -v -F --color=auto }


# generate password
function genpasswd() {
if [ $# -eq 1 ]; then local GENPASSLINE=$1;
elif [ $# -eq 0 ]; then local GENPASSLINE=8;
else echo "Please give the number of digits in the password you want to generate in the first argument. With no arguments to generate the 8-digit password"
fi;
  tr -dc a-z0-9 < /dev/urandom | head -c ${GENPASSLINE} | xargs
}


# Gitのリポジトリのトップレベルにcd
function gitroot()
{
cd ./$(git rev-parse --show-cdup)
if [ $# = 1 ]; then
cd $1
fi
}


# peco-man
function peco-man-list-all() {
    local parent dir file
    local paths=("${(s/:/)$(man -aw)}")
    for parent in $paths; do
        for dir in $(/bin/ls -1 $parent); do
            local p="${parent}/${dir}"
            if [ -d "$p" ]; then
                IFS=$'\n' local lines=($(/bin/ls -1 "$p"))
                for file in $lines; do
                    echo "${p}/${file}"
                done
            fi
        done
    done
}

function peco-man() {
    local selected=$(peco-man-list-all | peco --prompt 'man >')
    if [[ "$selected" != "" ]]; then
        man "$selected"
    fi
}
zle -N peco-man


# peco-src-remote
function peco-src-remote () {
    hub browse $(ghq list | peco | cut -d "/" -f 2,3)
}
zle -N peco-src-remote
bindkey '^x^g' peco-src-remote


# terminalからmagit-statusできるように
function magit-status(){
    emacsclient -e "(magit-status \"./$(git rev-parse --show-cdup)\")" 2>&1 >/dev/null & wmctrl -a emacs
}
zle -N magit-status
bindkey '^xg' magit-status
