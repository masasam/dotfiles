;;; 27rust.el --- 27rust.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package rust-ts-mode
  :mode ("\\.rs\\'" . rust-ts-mode)
  :hook (rust-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 27rust.el ends here
