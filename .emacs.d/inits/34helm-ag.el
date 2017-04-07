;; helm-ag
(require 'helm-files)
(require 'helm-ag)
(require 'bind-key)
(bind-key "M-g ." 'helm-ag)
(bind-key "M-g ," 'helm-ag-pop-stack)
(bind-key "C-M-s" 'helm-ag-this-file)
(custom-set-variables
 '(helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
 '(helm-ag-command-option "--all-text")
 '(helm-ag-insert-at-point 'symbol))
