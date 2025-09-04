;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package python-ts-mode
  :mode ("\\.py$" . python-ts-mode)
  ;; :config
  ;; (setq python-indent-guess-indent-offset-verbose nil)
  :hook
  (python-ts-mode . eglot-ensure))

;; (add-hook 'python-mode-hook (lambda ()
;;                               (require 'lsp-pyright)
;;                               (lsp-deferred)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
