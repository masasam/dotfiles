;;; 26javascript.el --- 26javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))

(add-hook 'js2-mode-hook 'eglot-ensure)

;; (require 'lsp-mode)
;; (add-to-list 'auto-minor-mode-alist '("\.vue\\'" . lsp))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26javascript.el ends here
