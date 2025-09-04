;;; 24elixir.el --- 24elixir.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package elixir-ts-mode
  :mode ("\\.ex\\'" . elixir-ts-mode)
  :hook (elixir-ts-mode . eglot-ensure))

;;; 24elixir.el ends here
