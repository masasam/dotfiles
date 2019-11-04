;;; 03popwin.el --- 03popwin.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; popwin
(require 'popwin)
(popwin-mode 1)

;; M-!
(push "*Shell Command Output*" popwin:special-display-config)

;; trashed
(push "Trash Can" popwin:special-display-config)

;; M-x compile
(push '(compilation-mode :noselect t) popwin:special-display-config)

;; slime
(push "*slime-apropos*" popwin:special-display-config)
(push "*slime-macroexpansion*" popwin:special-display-config)
(push "*slime-description*" popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push "*slime-xref*" popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push 'slime-repl-mode popwin:special-display-config)
(push 'slime-connection-list-mode popwin:special-display-config)

;; vc
(push "*vc-diff*" popwin:special-display-config)
(push "*vc-change-log*" popwin:special-display-config)

;; google-translate
(push "*Google Translate*" popwin:special-display-config)

;;; 03popwin.el ends here
