;;; 03shackle.el --- 03shackle.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'shackle)
(shackle-mode 1)
(setq shackle-rules '(("*Help*" :align below :select t)
					  ("*quickrun*" :align below :select t)
					  ("*eldoc*" :align below :select t)
					  ("*eldoc for shackle-mode*" :align below :select t)
					  ("*Ibuffer*" :align below :select t)
					  ("*Shell Command Output*" :align below :select t)
					  ("*vc-diff*" :align below :select t)
					  ("*vc-change-log*" :align below :select t)
					  ("*Google Translate*" :align below :select t)
					  ("Trash Can" :align below :select t)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 03shackle.el ends here
