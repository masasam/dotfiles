;; expand-region
(require 'expand-region)
(push 'er/mark-outside-pairs er/try-expand-list)
(global-set-key (kbd "C-M-SPC") 'er/expand-region)
