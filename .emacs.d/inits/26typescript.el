;;; 26typescript.el --- 26typescript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-to-list 'auto-mode-alist (cons "\\.ts\\'" 'typescript-ts-mode))
(add-hook 'dprint-on-save-mode 'eglot-ensure)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26typescript.el ends here
