;;; 23go.el --- 23go.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'go-mode-hook 'eglot-ensure)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook #'gofmt-before-save)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls"))))

;;; 23go.el ends here
