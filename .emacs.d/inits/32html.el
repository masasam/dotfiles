;;; 32html.el --- 32html.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package html-ts-mode
  :mode (("\\.html?\\'" . html-ts-mode)
		 ("\\.tpl?\\'"  . html-ts-mode)
		 ("\\.erb?\\'"  . html-ts-mode))
  :hook
  (html-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 32html.el ends here
