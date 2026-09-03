;;; 24elixir.el --- 24elixir.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package elixir-ts-mode
  :mode (("\\.elixir\\'" . elixir-ts-mode)
		 ("\\.ex\\'" . elixir-ts-mode)
		 ("\\.exs\\'" . elixir-ts-mode)
		 ("mix\\.lock" . elixir-ts-mode))
  :hook (elixir-ts-mode . (lambda ()
			    (my/eglot-ensure-if-program
			     "language_server.sh" "start_lexical.sh"))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 24elixir.el ends here
