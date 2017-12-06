(setq tramp-default-method "ssh")
(defalias 'exit-tramp 'tramp-cleanup-all-buffers)
(define-key global-map (kbd "C-c s") 'counsel-tramp)
(setq counsel-tramp-docker-user "username")
(setq counsel-tramp-docker-user '("username1" "username2" "username3" "username4"))

;; helm-ghq run with counsel
(bind-key "C-x l" 'counsel-ghq)
(bind-key "C-x C-l" 'counsel-ghq)
(require 'helm-ghq)
(defun counsel-ghq ()
  (interactive)
  (counsel-find-file (ivy-read "ghq list: " (helm-ghq--list-candidates))))
