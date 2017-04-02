;; helm-swoop
(require 'bind-key)
(bind-key "M-i" 'helm-swoop)
(bind-key "M-I" 'helm-swoop-back-to-last-point)
(bind-key "C-c M-i" 'helm-multi-swoop)
(bind-key "C-x M-i" 'helm-multi-swoop-all)
