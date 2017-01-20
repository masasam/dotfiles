(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "<f5>") 'quickrun-sc)

(defun quickrun-sc (start end)
(interactive "r")
(if mark-active
    (quickrun :start start :end end)
  (quickrun)))
