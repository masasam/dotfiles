;; magit
(autoload 'magit-status "magit" nil t)
(bind-key "C-x g" 'magit-status)
(bind-key "C-x G" 'magit-blame)


;; keychain-environment
(keychain-refresh-environment)


;; git-gutter
(global-git-gutter-mode t)
(bind-key "C-x v =" 'git-gutter:popup-hunk)
(bind-key "C-x v s" 'git-gutter:stage-hunk)
(bind-key "C-x v r" 'git-gutter:revert-hunk)
