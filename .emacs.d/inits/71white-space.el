;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace t)

(defun my/disable-trailing-mode ()
  "Disable show tail whitespace."
  (setq show-trailing-whitespace nil))

(add-hook 'term-mode-hook 'my/disable-trailing-mode)
(add-hook 'eshell-mode-hook 'my/disable-trailing-mode)
(add-hook 'markdown-mode-hook 'my/disable-trailing-mode)


;; Remove contiguous line breaks at end of line + end of file
(defun my/cleanup-for-spaces ()
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))
