(with-eval-after-load 'direx
  (push '(direx:direx-mode :position left :width 25 :dedicated t)
	popwin:special-display-config))
(bind-key "C-x C-j" 'direx:jump-to-directory-other-window)
(bind-key "C-x j" 'direx:jump-to-directory-other-window)

(with-eval-after-load 'dired
  (bind-key "e" 'wdired-change-to-wdired-mode dired-mode-map)
  (defun my/dropbox ()
    (interactive)
    (find-file "~/Dropbox/"))
  (defun my/downloads ()
    (interactive)
    (find-file "~/Downloads/"))
  (defun my/githubimage ()
    (interactive)
    (find-file "~/Pictures/image/")))
