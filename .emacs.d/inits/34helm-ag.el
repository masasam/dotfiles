;; helm-ag
(require 'helm-files)
(require 'helm-ag)
(bind-key "M-g ." 'helm-ag)
(bind-key "M-g ," 'helm-ag-pop-stack)
(custom-set-variables
 '(helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
 '(helm-ag-command-option "--all-text")
 '(helm-ag-insert-at-point 'symbol))
