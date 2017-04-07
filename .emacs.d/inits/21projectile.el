(projectile-mode)
(setq projectile-completion-system 'helm)
(require 'helm-projectile)
(helm-projectile-on)


(progn
  (custom-set-variables
   '(helm-truncate-lines t)
   '(helm-delete-minibuffer-contents-from-point t)
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-files-in-current-dir
                                 helm-source-recentf
				 helm-source-projectile-files-list
                                 ))))


;; helm-projectile
(setq helm-projectile-fuzzy-match nil)
;; How to clear cache (M-x projectile-invalidate-cache)
(setq projectile-enable-caching t)


;; require ggtags
(setq projectile-tags-file-name "GTAGS")
(setq projectile-tags-command "gtags")
