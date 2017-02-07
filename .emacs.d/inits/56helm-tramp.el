(defalias 'exit-tramp 'tramp-cleanup-all-buffers)
(require 'bind-key)
(bind-key "C-c s" 'helm-tramp)
