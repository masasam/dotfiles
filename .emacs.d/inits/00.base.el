;; 基本utf-8でファイルの指定コードがあればそれで保存
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;; GCを減らして高速化(メモリは食う)
(setq gc-cons-threshold (* 128 1024 1024))


;;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)


;; font
(add-to-list 'default-frame-alist '(font . "ricty-15.5"))


; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))



;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)
;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)



;; Ctrl-hをbackspace
(define-key global-map "\C-h" 'delete-backward-char)

;; backspaceキーをインクリメンタルサーチ中のミニバッファで有効にする
(define-key isearch-mode-map "\C-h" 'isearch-delete-char)

;; C-h に割り当てられている関数 help-command を C-x C-h に割り当てる
(define-key global-map "\C-x\C-h" 'help-command)

;; C-x C-k でも C-x k と同じ kill-buffer を実行
(define-key global-map "\C-x\C-k" 'kill-buffer)

;; C-x C-dもdiredにする
(global-set-key (kbd "C-x C-d") 'dired)

;; minibuffer-local-completion-mpa
(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)

;; マウスカーソルとテキストカーソルが近い場合にマウスがよけてくれる
(if (display-mouse-p) (mouse-avoidance-mode 'exile))

;; 自動セーブを無効
(setq auto-save-default nil)

;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "Emacs@%s : %%f" (system-name)))

;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; 同名ファイルのとき見やすくする
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; カーソルの位置が何文字目かを表示する
(column-number-mode t)

;; 履歴数を大きくする
(setq history-length 10000)

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; "yes or no"を"y or n"にする
(fset 'yes-or-no-p 'y-or-n-p)

;; 警告音を消す
(setq visible-bell nil)

;; C-u C-SPC C-SPC …でどんどん過去のマークを遡る
(setq set-mark-command-repeat-pop t)



;; X11のクリップボードを使う
(setq x-select-enable-clipboard t)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-w" 'clipboard-kill-region)



;; 対応する括弧を光らせる
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match-face nil
                    :background nil :foreground nil
                    :underline "#ffff00" :weight 'extra-bold)


;; diredで消したファイルはゴミ箱へ
(setq delete-by-moving-to-trash t)
