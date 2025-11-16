;;; 26typescript.el --- 26typescript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package tsx-ts-mode
  :mode ("\\.tsx\\'" . tsx-ts-mode)
  :hook (tsx-ts-mode . eglot-ensure))

(use-package typescript-ts-mode
  :mode ("\\.ts\\'" . typescript-ts-mode)
  :hook (typescript-ts-mode . eglot-ensure))

(use-package json-ts-mode
  :mode
  ("\\.json\\'" . json-ts-mode)
  :hook (json-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26typescript.el ends here
