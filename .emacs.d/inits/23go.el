;;; 23go.el --- 23go.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'go-mode-hook 'eglot-ensure)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook #'gofmt-before-save)
(add-hook 'go-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4)
	     (setq indent-tabs-mode nil)
	     (setq tab-width 4)))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(go-mode . ("gopls"))))

;;; 23go.el ends here
