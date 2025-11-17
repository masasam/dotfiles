;;; 94lisp.el --- 94lisp.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook #'aggressive-indent-mode)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 94lisp.el ends here
