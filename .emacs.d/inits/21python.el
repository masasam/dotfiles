;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq python-indent-guess-indent-offset-verbose nil)

(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'eglot-managed-mode-hook 'flymake-ruff-load)

;; (add-hook 'python-mode-hook (lambda ()
;;                               (require 'lsp-pyright)
;;                               (lsp-deferred)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
