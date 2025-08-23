;;; 26typescript.el --- 26typescript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package treesit
  :config
  (setq treesit-font-lock-level 4))

(add-to-list 'auto-mode-alist (cons "\\.tsx\\'" 'tsx-ts-mode))
(add-to-list 'auto-mode-alist (cons "\\.ts\\'" 'typescript-ts-mode))
(add-hook 'tsx-ts-mode 'eglot-ensure)
(add-hook 'typescript-ts-mode 'eglot-ensure)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26typescript.el ends here
