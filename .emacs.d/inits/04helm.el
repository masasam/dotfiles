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


;; helm-recentf
(define-key global-map (kbd "C-c f") 'helm-recentf)
(define-key global-map (kbd "C-c C-f") 'helm-recentf)
;; Follow gloval-mark with helm
(define-key global-map (kbd "C-x m") 'helm-all-mark-rings)
;; Helm C-h delete previous character
(define-key helm-map (kbd "C-h") 'delete-backward-char)
;; Segment delete with helm C-w
(define-key helm-map (kbd "C-w") 'backward-kill-word)


;; Keybind
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


;; helm-ag
(require 'helm-files)
(require 'helm-ag)
(global-set-key (kbd "M-g .") 'helm-ag)
(global-set-key (kbd "M-g ,") 'helm-ag-pop-stack)
(global-set-key (kbd "C-M-s") 'helm-ag-this-file)
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
     (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)))



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
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)



;; helm-multi-files  recentf
(setq recentf-max-saved-items 1000)



;; helm-descbinds
(require 'helm-descbinds)
(helm-descbinds-mode)
