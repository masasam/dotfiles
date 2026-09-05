;;; 27rust.el --- 27rust.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun my/project-try-cargo (directory)
  "Return a project rooted at the nearest Cargo.toml above DIRECTORY."
  (when-let* ((root (locate-dominating-file directory "Cargo.toml")))
    (cons 'transient root)))

(defun my/rust-eglot-ensure ()
  "Start Eglot with the nearest Cargo package as its project root."
  (add-hook 'project-find-functions #'my/project-try-cargo nil t)
  (eglot-ensure))

(use-package rust-ts-mode
  :mode ("\\.rs\\'" . rust-ts-mode)
  :hook (rust-ts-mode . my/rust-eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 27rust.el ends here
