(require 'dired)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)

(defun my/reset-default-directory-by-buffer-file-name ()
  "Set default-directory by `buffer-file-name'."
  (interactive)
  (require 'f)
  (when buffer-file-name
    (setq default-directory (f-dirname buffer-file-name))))

;; Open dropbox with dired
(defun dropbox ()
  (interactive)
  (find-file "~/Dropbox/"))

;; Open ~/Pictures/image with dired
(defun githubimage ()
  (interactive)
  (find-file "~/Pictures/image/"))
