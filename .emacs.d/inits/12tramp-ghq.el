(setq tramp-default-method "ssh")
(defalias 'exit-tramp 'tramp-cleanup-all-buffers)
(define-key global-map (kbd "C-c s") 'counsel-tramp)

;; helm-ghq run with counsel
(bind-key "C-x l" 'counsel-ghq)
(bind-key "C-x C-l" 'counsel-ghq)
(require 'helm-ghq)
(defun counsel-ghq ()
  (interactive)
  (counsel-find-file (ivy-read "ghq list:" (helm-ghq--list-candidates))))
