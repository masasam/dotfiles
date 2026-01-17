;;; 93popper.el --- 93popper.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; (require 'shackle)
;; (shackle-mode 1)
;; (setq shackle-rules '(("*Help*" :align below :select t)
;; 					  ("*quickrun*" :align below :select t)
;; 					  ("*eldoc*" :align below :select t)
;; 					  ("*eldoc for shackle-mode*" :align below :select t)
;; 					  ("*Ibuffer*" :align below :select t)
;; 					  ("*Shell Command Output*" :align below :select t)
;; 					  ("*vc-diff*" :align below :select t)
;; 					  ("*vc-change-log*" :align below :select t)
;; 					  ("*Google Translate*" :align below :select t)
;; 					  ("Trash Can" :align below :select t)))

(use-package popper
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
		  "\\*gt-result\\*"
          "Output\\*$"
		  "\\*Google Translate\\*$"
		  "\\*quickrun\\*"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode
		  "^\\*eshell.*\\*$" eshell-mode
		  "^\\*shell.*\\*$"  shell-mode
		  "^\\*term.*\\*$"   term-mode
		  "^\\*vterm.*\\*$"  vterm-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 93popper.el ends here
