;;; 30css.el --- 30css.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode))

(use-package css-ts-mode
  :hook
  (css-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 30css.el ends here
