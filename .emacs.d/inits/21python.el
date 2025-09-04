;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package python-ts-mode
  :mode ("\\.py$" . python-ts-mode)
  :hook
  (python-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
