;; helm-tramp run with counsel
(require 'helm-tramp)
(defun counsel-tramp ()
  (interactive)
  (counsel-find-file (ivy-read "Tramp:" (helm-tramp--candidates))))
(defalias 'quit-tramp 'tramp-cleanup-all-buffers)
(bind-key "C-c s" 'counsel-tramp)
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq helm-tramp-docker-user '("admin" "user" "masa"))


;; helm-ghq run with counsel
(bind-key "C-x l" 'counsel-ghq)
(bind-key "C-x C-l" 'counsel-ghq)
(require 'helm-ghq)
(defun counsel-ghq ()
  (interactive)
  (counsel-find-file (ivy-read "ghq list:" (helm-ghq--list-candidates))))
