;; helm
(require 'helm-config)
(helm-mode 1)


;; helm-key
(bind-key "C-c h" 'helm-command-prefix)
;; It does not end with C-x C-c
(bind-key "C-x C-c" 'helm-M-x)
;; helm-mini
(bind-key "C-;" 'helm-mini)
(bind-key "C-;" 'helm-keyboard-quit helm-map)
;; helm-recentf
(bind-key "C-x C-r" 'helm-recentf)
;; helm-resume
(bind-key "C-z" 'helm-resume)
(bind-key "C-x C-z" 'helm-resume)
;; Follow gloval-mark with helm
(bind-key "C-x m" 'helm-all-mark-rings)
;; Helm C-h delete previous character
(bind-key "C-h" 'delete-backward-char helm-map)
;; Segment delete with helm C-w
(bind-key "C-w" 'backward-kill-word helm-map)
;; helm-for-files
(bind-key "C-x b" 'helm-for-files)
;; helm-M-x
(bind-key "M-x" 'helm-M-x)
;; kill-ring
(bind-key "M-y" 'helm-show-kill-ring)
;; show keybind
;;(bind-key "C-c b" 'helm-descbinds)
;; chrome bookmark
;;(bind-key "C-c b" 'helm-chrome-bookmarks)
;; helm find files
(bind-key "C-x C-f" 'helm-find-files)
(bind-key "C-h" 'delete-backward-char helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-find-files-map)
(bind-key "TAB" 'helm-execute-persistent-action helm-read-file-map)
;; helm-browse-project
(bind-key "C-x C-d" 'helm-browse-project)
;; helm-next helm-previous
(bind-key "C-M-n" 'helm-next-source helm-map)
(bind-key "C-M-p" 'helm-previous-source helm-map)


;; fuzzy-match
(setq helm-buffers-fuzzy-matching t)
(setq helm-recentf-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
(setq helm-apropos-fuzzy-match t)
(setq helm-locate-fuzzy-match t)


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


;; helm-multi-files  recentf
(setq recentf-max-saved-items 1000)


;; helm-descbinds
(require 'helm-descbinds)
(helm-descbinds-mode)


;; M-x helm-info-emacs251-ja
(add-to-list 'Info-directory-list "~/.emacs.d/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  (apply orig-fn
         (pcase filename
           ("emacs" "emacs251-ja")
           (_ filename))
         args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)


;; helm-swoop
(bind-key "M-i" 'helm-swoop)
(bind-key "M-I" 'helm-swoop-back-to-last-point)
(bind-key "C-c M-i" 'helm-multi-swoop)
(bind-key "C-x M-i" 'helm-multi-swoop-all)


;; helm-directory
(bind-key "C-c l" 'helm-directory)
(bind-key "C-c C-l" 'helm-directory)


;; helm-tramp
(setq tramp-default-method "ssh")
(defalias 'quit-tramp 'tramp-cleanup-all-buffers)
(bind-key "C-c s" 'helm-tramp)
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq helm-tramp-docker-user '("admin" "user" "masa"))


;; helm-ghq
(bind-key "C-x l" 'helm-ghq)
(bind-key "C-x C-l" 'helm-ghq)
