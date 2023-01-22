;;; 26javascript.el --- 26javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))

(add-hook 'js2-mode-hook 'eglot-ensure)
(add-hook 'typescript-mode-hook 'eglot-ensure)
(add-hook 'rjsx-mode-hook 'eglot-ensure)
(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq js-indent-level 2)
            (setq js2-strict-missing-semi-warning nil)))

;; (require 'lsp-mode)
;; (add-to-list 'auto-minor-mode-alist '("\.vue\\'" . lsp))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26javascript.el ends here
