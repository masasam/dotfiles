;;; 25javascript.el --- 25javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package js-ts-mode
  :hook
  (js-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(javascript-mode . js-ts-mode)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 25javascript.el ends here
