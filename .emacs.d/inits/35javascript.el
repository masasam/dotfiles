;;; 35javascript.el --- 35javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode))

(use-package js-ts-mode
  :hook
  (js-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 35javascript.el ends here
