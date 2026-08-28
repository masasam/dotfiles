;;; 20treesit.el --- 20treesit.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package treesit
  :config
  (setq treesit-font-lock-level 4)
  (when (> emacs-major-version 30)
    (setq treesit-auto-install-grammar 'always
          treesit-enabled-modes t)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 20treesit.el ends here
