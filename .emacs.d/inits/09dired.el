(require 'dired)
(define-key dired-mode-map "e" 'wdired-change-to-wdired-mode)

(defun my/reset-default-directory-by-buffer-file-name ()
  "Set default-directory by `buffer-file-name'."
  (interactive)
  (require 'f)
  (when buffer-file-name
    (setq default-directory (f-dirname buffer-file-name))))

;; dropboxをdiredで開く
(defun dropbox ()
  (interactive)
  (find-file "~/Dropbox/"))

;; Pictures/imageをdiredで開く
(defun githubimage ()
  (interactive)
  (find-file "~/Pictures/image/"))
