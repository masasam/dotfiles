;; magit
(autoload 'magit-status "magit" nil t)
(bind-key "C-x g" 'magit-status)
(bind-key "C-x G" 'magit-blame)


;; git-gutter
(global-git-gutter-mode t)
