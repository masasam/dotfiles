;;; 26typescript.el --- 26typescript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package tsx-ts-mode
  :mode (("\\.ts[x]?\\'" . tsx-ts-mode)
         ("\\.[m]ts\\'" . tsx-ts-mode))
  :hook (tsx-ts-mode . eglot-ensure))

(use-package json-ts-mode
  :mode
  ("\\.json\\'" . json-ts-mode)
  :hook (json-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26typescript.el ends here
