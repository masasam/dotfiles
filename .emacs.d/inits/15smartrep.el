(smartrep-define-key global-map "C-x"
  '(("o" . other-window-or-split)
    ("0" . delete-window)
    ("1" . delete-other-windows)
    ("2" . split-window-below)
    ("3" . split-window-right)
    ("{" . shrink-window-horizontally)
    ("}" . enlarge-window-horizontally)
    ("+" . balance-windows)
    ("^" . enlarge-window)
    ("-" . shrink-window)))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(setq smartrep-mode-line-active-bg "#2f4f4f")
