(require 'dired)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)

(require 'direx)
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(bind-key "C-x C-j" 'direx:jump-to-directory-other-window)
(bind-key "C-x j" 'direx:jump-to-directory-other-window)

;; Open dropbox with dired
(defun my/dropbox ()
  (interactive)
  (find-file "~/Dropbox/"))

;; Open downloads with dired
(defun my/downloads ()
  (interactive)
  (find-file "~/Downloads/"))

;; Open ~/Pictures/image with dired
(defun my/githubimage ()
  (interactive)
  (find-file "~/Pictures/image/"))
