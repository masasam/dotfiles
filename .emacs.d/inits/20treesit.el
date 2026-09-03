;;; 20treesit.el --- 20treesit.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'seq)
(require 'subr-x)

(use-package treesit
  :config
  (setq treesit-font-lock-level 4)
  (when (> emacs-major-version 30)
    (setq treesit-auto-install-grammar 'always
          treesit-enabled-modes t)))

(defun my/eglot-ensure-if-program (&rest programs)
  "Start Eglot when one of PROGRAMS is available.
Otherwise, report which language-server executables are needed."
  (if (seq-some #'executable-find programs)
      (eglot-ensure)
    (message "Eglot not started: install one of %s"
	     (string-join programs ", "))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 20treesit.el ends here
