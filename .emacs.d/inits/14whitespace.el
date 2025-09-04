;;; 17whitespace.el --- 17whitespace.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace nil)

(defun my/enable-trailing-mode ()
  "Show tail whitespace."
  (setq show-trailing-whitespace t))

(add-hook 'emacs-lisp-mode-hook 'my/enable-trailing-mode)
(add-hook 'python-mode-hook 'my/enable-trailing-mode)
(add-hook 'ruby-mode-hook 'my/enable-trailing-mode)
(add-hook 'c-mode-hook 'my/enable-trailing-mode)
(add-hook 'shell-mode-hook 'my/enable-trailing-mode)
(add-hook 'js2-mode-hook 'my/enable-trailing-mode)
(add-hook 'web-mode-hook 'my/enable-trailing-mode)
(add-hook 'elixir-mode-hook 'my/enable-trailing-mode)


(defun my/cleanup-for-spaces ()
  "Remove contiguous line breaks at end of line + end of file."
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 17whitespace.el ends here
