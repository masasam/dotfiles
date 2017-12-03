;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace nil)

(defun my/disable-trailing-mode ()
  "Disable show tail whitespace."
  (setq show-trailing-whitespace t))

(add-hook 'emacs-lisp-mode-hook 'my/disable-trailing-mode)
(add-hook 'python-mode-hook 'my/disable-trailing-mode)
(add-hook 'c-mode-hook 'my/disable-trailing-mode)
(add-hook 'shell-mode-hook 'my/disable-trailing-mode)


;; Remove contiguous line breaks at end of line + end of file
(defun my/cleanup-for-spaces ()
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))
