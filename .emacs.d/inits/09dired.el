(require 'dired)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)

(defun my/reset-default-directory ()
  "Set default-directory by `buffer-file-name'."
  (interactive)
  (require 'f)
  (when buffer-file-name
    (setq default-directory (f-dirname buffer-file-name))))

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
