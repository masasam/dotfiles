# zshrc
plugins=(… zsh-completions)
autoload -U compinit promptinit
compinit
promptinit

export LANG=ja_JP.UTF-8

autoload -Uz colors
colors

# 改行コード(\n)で終わっていない出力のとき最終行がでないのを防ぐ
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
setopt hist_ignore_dups      # 直前と同じコマンドはヒストリに追加しない
setopt hist_ignore_space     # スペースで始まるコマンド行はヒストリリストから削除
unsetopt hist_verify         # ヒストリを呼び出してから実行する間に一旦編集可能を止める
setopt hist_reduce_blanks    # 余分な空白は詰めて記録
setopt hist_save_no_dups     # ヒストリファイルに書き出すときに、古いコマンドと同じものは無視する。
setopt hist_no_store         # historyコマンドは履歴に登録しない
setopt hist_expand           # 補完時にヒストリを自動的に展開
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
setopt long_list_jobs        # 内部コマンドjobs の出力をデフォルトで jobs -L にする
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
# ディレクトリ名が引数のときに最後の / を削除しない
setopt noautoremoveslash

# sudoの補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

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

# 右プロンプトに現在地を表示。
RPROMPT="%{$fg_bold[white]%}[%{$reset_color%}%{$fg[cyan]%}%~%{$reset_color%}%{$fg_bold[white]%}]%{$reset_color%}"

# emacsキーバインド
bindkey -e

# 移動した場所を記録し、cd -[TAB] で以前移動したディレクトリの候補を提示してくれて、
# その番号を入力することで移動出来るようになる。
setopt auto_pushd

# auto_pushdで重複するディレクトリは記録しないようにする。
setopt pushd_ignore_dups

# コマンドのスペルミスを指摘して予想される正しいコマンドを提示してくれる。このときのプロンプトがSPROMPT。
setopt correct

# ファイル作成時のパーミッション
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


# tmux,screenに現在実行したコマンド名を渡す
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
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=aunpack #./hogefuga.tar.gz で解凍pacman -S atool
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
alias du='du -h'
alias df='df -h'
alias e='emacsclient'
alias open='xdg-open'
alias vim='nvim'
alias sudotramp='emacsclient -a emacs -n /sudo:$(grep -iE "host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias tramp='emacsclient -a emacs -n /ssh:$(grep -iE "host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}"):/ & wmctrl -a emacs'
alias trackpointspeed='xinput --set-prop 10 "Device Accel Constant Deceleration"'
alias caskupdate='rm -rf ${HOME}/Dropbox/emacs/cask/`ls -rt ${HOME}/Dropbox/emacs/cask | head -n 1`;tar cfz ${HOME}/Dropbox/emacs/cask/`date '+%Y%m%d%H%M%S'`.tar.gz -C ${HOME}/.emacs.d .cask;cd ${HOME}/.emacs.d/;cask upgrade;cask update;cd -'
alias caskinstall='cd ${HOME}/.emacs.d/;cask upgrade;cask install;cd -'
alias goupdate='go get -u all'
alias rust='cargo-script'
alias rustupdate='cargo install-update -a'
alias archupdate='yaourt -Syua; paccache -r'


# PATH
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.cask/bin"
export EDITOR='emacsclient'
export XDG_CONFIG_HOME=$HOME/.config
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=~/Dropbox/emacs/rustc-1.14.0/src


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


# pecoで書籍を開く
function peco-books() {
  local book="$(find ~/Dropbox/books -type f | peco)"
  if [ -n "$book" ]; then
      open $book
  fi
}
zle -N peco-books
bindkey '^xb' peco-books


# キーバインド
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


function emacsag() {
    emacsclient -n $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "+" $2 " " $1}')
}


# globalip
function globalip() {
    curl inet-ip.info
}


function _getgitignore() {
    curl -s https://www.gitignore.io/api/$1
}
alias getgitignore='_getgitignore $(_getgitignore list | sed "s/,/\n/g" | peco )'


# cdしたらls
function chpwd() {
    ls -v -F --color=auto
}


# Gitのリポジトリのトップレベルにcd
function gitroot() {
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
	cd $1
    fi
}


# zsh-syntax-highlighting(pacman -S zsh-syntax-highlighting)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
