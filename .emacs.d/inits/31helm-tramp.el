(setq tramp-default-method "ssh")
(defalias 'quit-tramp 'tramp-cleanup-all-buffers)
(bind-key "C-c s" 'helm-tramp)
;; Connect tramp with bash
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
;;(setq helm-tramp-docker-user "nginx")
(setq helm-tramp-docker-user '("admin" "user" "masa"))
