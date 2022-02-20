;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'python-mode-hook (lambda ()
                          (require 'lsp-pyright)
                          (lsp)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
