;;; 23go.el --- 23go.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package go-ts-mode
  :mode (("\\.go$" . go-ts-mode)
		 ("/go\\.mod\\'" . go-mod-ts-mode))
  :hook (go-ts-mode . eglot-ensure))

;;; 23go.el ends here
