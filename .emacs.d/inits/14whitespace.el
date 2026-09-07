;;; 17whitespace.el --- 17whitespace.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace nil)

(defun my/enable-trailing-mode ()
  "Show tail whitespace."
  (setq show-trailing-whitespace t))

(add-hook 'prog-mode-hook #'my/enable-trailing-mode)
;; `shell-mode' derives from `comint-mode', not `prog-mode'.
(add-hook 'shell-mode-hook #'my/enable-trailing-mode)


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
