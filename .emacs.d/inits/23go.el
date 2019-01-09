;;; 23go.el --- 23go.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; go-mode
(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'before-save-hook #'gofmt-before-save)
(add-hook 'go-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4)
	     (setq indent-tabs-mode t)))

(add-to-list 'eglot-server-programs '(go-mode . ("go-langserver" "-gocodecompletion")))

;;; 23go.el ends here
