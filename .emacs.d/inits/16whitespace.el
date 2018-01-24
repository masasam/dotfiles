;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace nil)

(defun my/enable-trailing-mode ()
  "Show tail whitespace."
  (setq show-trailing-whitespace t))

(add-hook 'emacs-lisp-mode-hook 'my/enable-trailing-mode)
(add-hook 'python-mode-hook 'my/enable-trailing-mode)
(add-hook 'enh-ruby-mode-hook 'my/enable-trailing-mode)
(add-hook 'c-mode-hook 'my/enable-trailing-mode)
(add-hook 'shell-mode-hook 'my/enable-trailing-mode)


;; Remove contiguous line breaks at end of line + end of file
(defun my/cleanup-for-spaces ()
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))
