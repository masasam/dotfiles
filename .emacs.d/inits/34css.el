;;; 34css.el --- 34css.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package css-ts-mode
  :hook
  (css-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34css.el ends here
