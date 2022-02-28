;;; 29sh.el --- 29sh.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'sh-mode-hook (lambda ()
                          (lsp)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 29sh.el ends here
