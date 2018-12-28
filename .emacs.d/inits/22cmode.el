;;; 22cmode.el --- 22cmode.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 22cmode.el ends here
