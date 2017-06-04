(setq tramp-default-method "ssh")
(defalias 'exit-tramp 'tramp-cleanup-all-buffers)
(require 'bind-key)
(bind-key "C-c s" 'helm-tramp)
;; Connect tramp with bash
(eval-after-load 'tramp '(setenv "SHELL" "/bin/bash"))
(setq helm-tramp-docker-user "nginx")
