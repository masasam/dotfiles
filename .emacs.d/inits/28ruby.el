;;; 28ruby.el --- 28ruby.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package ruby-ts-mode
  :hook
  (ruby-ts-mode . (lambda ()
		    (my/eglot-ensure-if-program "ruby-lsp" "solargraph")))
  :init
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  :config
  (setq ruby-insert-encoding-magic-comment nil))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 28ruby.el ends here
