;;; 24elixir.el --- 24elixir.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'elixir-mode-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs '(elixir-mode . ("sh" "/home/masa/src/github.com/JakeBecker/elixir-ls/rel/language_server.sh")))


;;; 24elixir.el ends here
