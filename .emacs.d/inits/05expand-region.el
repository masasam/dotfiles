;; expand-region
(require 'expand-region)
(require 'bind-key)
(push 'er/mark-outside-pairs er/try-expand-list)
(bind-key "C-M-SPC" 'er/expand-region)
