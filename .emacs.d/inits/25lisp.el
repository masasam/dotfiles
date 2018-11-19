;;; 25lisp.el --- 25lisp.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))
(add-hook 'lisp-mode-hook #'aggressive-indent-mode)
;; slime-company
(slime-setup '(slime-fancy slime-company))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 25lisp.el ends here
