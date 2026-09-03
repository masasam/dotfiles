;;; 96apheleia.el --- Format buffers asynchronously -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package apheleia
  :config
  ;; Keep formatting limited to the modes previously handled by reformatter.
  (setq apheleia-mode-alist
	'((go-ts-mode . goimports)
	  (tsx-ts-mode . prettier-typescript)
	  (json-ts-mode . prettier-json)
	  (python-ts-mode . ruff)
	  (zig-mode . zig-fmt)))
  (apheleia-global-mode 1))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 96apheleia.el ends here
