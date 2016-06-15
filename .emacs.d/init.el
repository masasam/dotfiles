;;; init.el --- myinit.el
;;; Commentary:
;;; Code:
(package-initialize)
(set-frame-parameter nil 'fullscreen 'maximized)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)


;; cask
(require 'cask "/usr/share/cask/cask.el")
(cask-initialize)

;; theme
(load-theme 'material t)
;(load-theme 'cyberpunk t)


;; 基本utf-8でファイルの指定コードがあればそれで保存
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;; GCを減らして高速化(メモリは食う)
(setq gc-cons-threshold (* 128 1024 1024))

;;; 右から左に読む言語に対応させないことで描画高速化
(setq-default bidi-display-reordering nil)


;; font
(add-to-list 'default-frame-alist '(font . "ricty-15.5"))
(custom-set-faces
 '(variable-pitch ((t (:family "Ricty"))))
 '(fixed-pitch ((t (:family "Ricty"))))
 )



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



;; git-gutter
(global-git-gutter-mode t)

(custom-set-variables
 '(git-gutter:handled-backends '(git hg bzr)))

(require 'smartrep)
(smartrep-define-key
    global-map  "C-x" '(("p" . 'git-gutter:previous-hunk)
                        ("n" . 'git-gutter:next-hunk)))



;; anzu
(global-anzu-mode +1)

(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

(custom-set-variables
 '(anzu-mode-lighter "")
 '(anzu-deactivate-region t)
 '(anzu-use-migemo nil)
 '(anzu-search-threshold 1000))



;; helm
(require 'helm-config)
(helm-mode 1)
(progn
  (require 'helm-projectile)
  (custom-set-variables
   '(helm-truncate-lines t)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-files-in-current-dir
                                 helm-source-recentf
				 helm-source-projectile-files-list
                                 ))))
(define-key global-map (kbd "C-;") 'helm-mini)



;; helm C-hで前の文字削除
(define-key helm-map (kbd "C-h") 'delete-backward-char)
;; helm C-wで分節削除
(define-key helm-map (kbd "C-w") 'backward-kill-word)


;; キーバインド
(define-key helm-map (kbd "C-;") 'helm-keyboard-quit)
(define-key global-map (kbd "C-x b") 'helm-for-files)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c b") 'helm-descbinds)


;; Helm KeyBind remap
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)



;; helm find files
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)



;; ;; helm-ag
(require 'helm-files)
(require 'helm-ag)
(global-set-key (kbd "M-g .") 'helm-ag)
(global-set-key (kbd "M-g ,") 'helm-ag-pop-stack)
(global-set-key (kbd "C-M-s") 'helm-ag-this-file)



;;; Enable helm-gtags-mode
;; gtags --gtagslabel=ctags で作成
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-auto-update t))

;; key bindings
(eval-after-load "helm-gtags"
  '(progn
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))



;; helm-projectile
(require 'helm-projectile)
;; cacheをクリアするには　M-x projectile-invalidate-cache
(custom-set-variables
 '(projectile-enable-caching t))
(projectile-global-mode t)

;; プロジェクトに関連するファイルをhelm-for-filesに追加
(defadvice helm-for-files (around update-helm-list activate)
  (let ((helm-for-files-preferred-list
         (helm-for-files-update-list)))
    ad-do-it))

(defun helm-for-files-update-list ()
  `(helm-source-buffers-list
    helm-source-files-in-current-dir
    helm-source-recentf
    helm-source-file-cache
    ,(if (projectile-project-p)
     helm-source-projectile-files-list)))

;; helm-agをプロジェクトルートから
(defun projectile-helm-ag ()
  (interactive)
  (helm-ag (projectile-project-root)))



;; helm-swoop
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)



;; helm-multi-files  recentf
(setq recentf-max-saved-items 1000)



;; helm-descbinds
(require 'helm-descbinds)
(helm-descbinds-mode)



;; magit
(autoload 'magit-status "magit" nil t)
(global-set-key "\C-xg" 'magit-status)



;; Auto Complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'fundamental-mode)
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'markdown-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチ



;; popwin
(require 'popwin)
(popwin-mode 1)



;; google-translate
(require 'google-translate)
(use-package google-translate
  :config
  (global-set-key (kbd "C-c t") 'google-translate-at-point)

  ; en -> ja
  (custom-set-variables
    '(google-translate-default-source-language "en")
    '(google-translate-default-target-language "ja"))

  (with-eval-after-load 'popwin
    (push "*Google Translate*" popwin:special-display-config)))



(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(push '("emacs.+/snippets/" . snippet-mode) auto-mode-alist)
(yas-global-mode 1)



;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)



;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)



;; editorconfig
(editorconfig-mode 1)



;; tramp
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '("localhost" nil nil))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))



;; diredで消したファイルはゴミ箱へ
(setq delete-by-moving-to-trash t)



;; google-this
(global-set-key "\C-cg" 'google-this)



;; go-mode
(setenv "GOPATH" "/home/masa/go")
(add-to-list 'exec-path (expand-file-name "/home/masa/go/bin"))

(with-eval-after-load 'go-mode
  ;; auto-complete
  (require 'go-autocomplete)

  ;; company-mode
  ;(add-to-list 'company-backends 'company-go)

  ;; eldoc
  (add-hook 'go-mode-hook 'go-eldoc-setup)

  (add-hook 'before-save-hook 'gofmt-before-save)
  
  ;; key bindings
  (define-key go-mode-map (kbd "M-.") 'godef-jump)
  (define-key go-mode-map (kbd "M-,") 'pop-tag-mark))



;;; 全角文字と半角英字の間に半角スペースを入れる
(setq pangu-spacing-chinese-before-english-regexp
  (rx (group-n 1 (category japanese))
      (group-n 2 (in "a-zA-Z0-9"))))
(setq pangu-spacing-chinese-after-english-regexp
  (rx (group-n 1 (in "a-zA-Z0-9"))
      (group-n 2 (category japanese))))
;;; 見た目ではなくて実際にスペースを入れる
(setq pangu-spacing-real-insert-separtor t)
;; markdown-modeで利用する
(add-hook 'markdown-mode-hook 'pangu-spacing-mode)



(provide 'init)
;;; init.el ends here

