;; helm
(require 'helm-config)
(require 'bind-key)
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
(bind-key "C-;" 'helm-mini)
;; helm-mini fuzzy-matching
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)


;; helm-recentf
(bind-key "C-c f" 'helm-recentf)
(bind-key "C-c C-f" 'helm-recentf)
;; Follow gloval-mark with helm
(bind-key "C-x m" 'helm-all-mark-rings)
;; Helm C-h delete previous character
(bind-key "C-h" 'delete-backward-char helm-map)
;; Segment delete with helm C-w
(bind-key "C-w" 'backward-kill-word helm-map)


;; Keybind
(bind-key "C-;" 'helm-keyboard-quit helm-map)
(bind-key "C-x b" 'helm-for-files)
(bind-key "M-x" 'helm-M-x)
(bind-key "M-y" 'helm-show-kill-ring)
(bind-key "C-c b" 'helm-descbinds)


;; Helm KeyBind remap
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)


;; helm find files
(bind-key "C-x C-f" 'helm-find-files)
(bind-key "C-h" 'delete-backward-char helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-read-file-map)


;; helm-ag
(require 'helm-files)
(require 'helm-ag)
(bind-key "M-g ." 'helm-ag)
(bind-key "M-g ," 'helm-ag-pop-stack)
(bind-key "C-M-s" 'helm-ag-this-file)
;; Use ripgrep with helm-ag
(setq helm-ag-base-command "rg --vimgrep --no-heading")
;; Make the current symbol the default query
(setq helm-ag-insert-at-point 'symbol)


;; Enable helm-gtags-mode
;; it makes this command(gtags --gtagslabel=ctags)
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
     (bind-key "M-t" 'helm-gtags-find-tag helm-gtags-mode-map)
     (bind-key "M-r" 'helm-gtags-find-rtag helm-gtags-mode-define)
     (bind-key "M-s" 'helm-gtags-find-symbol helm-gtags-mode-map)
     (bind-key "M-g M-p" 'helm-gtags-parse-file helm-gtags-mode-map)
     (bind-key "C-c <" 'helm-gtags-previous-history helm-gtags-mode-map)
     (bind-key "C-c >" 'helm-gtags-next-history helm-gtags-mode-map)
     (bind-key "M-," 'helm-gtags-pop-stack helm-gtags-mode-map)))


;; helm-projectile
(require 'helm-projectile)
;; How to clear cache (M-x projectile-invalidate-cache)
(custom-set-variables
 '(projectile-enable-caching t))
(projectile-global-mode t)

;; Add files related to project to helm-for-files
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

;; From the project route helm-ag
(defun projectile-helm-ag ()
  (interactive)
  (helm-ag (projectile-project-root)))



;; helm-swoop
(bind-key "M-i" 'helm-swoop)
(bind-key "M-I" 'helm-swoop-back-to-last-point)
(bind-key "C-c M-i" 'helm-multi-swoop)
(bind-key "C-x M-i" 'helm-multi-swoop-all)



;; helm-multi-files  recentf
(setq recentf-max-saved-items 1000)



;; helm-descbinds
(require 'helm-descbinds)
(helm-descbinds-mode)



;; helm-M-x-fuzzy-match
(setq helm-M-x-fuzzy-match t)
