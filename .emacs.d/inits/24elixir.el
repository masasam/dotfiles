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
			     "elixir-ls" "language_server.sh"
			     "start_lexical.sh"))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(elixir-ts-mode . ("elixir-ls"))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 24elixir.el ends here
