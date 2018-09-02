;; dired
(with-eval-after-load 'dired
  (bind-key "e" 'wdired-change-to-wdired-mode dired-mode-map)
  (defun my/password ()
    (interactive)
    (find-file "~/Dropbox/passwd/pass.gpg"))
  (defun kanban ()
    (interactive)
    (find-file "~/Dropbox/kanban/doc.txt"))
  (defun kanban-rename ()
    (interactive)
    ;; (buffer-file-name "~/Dropbox/kanban/doc.txt")
    (rename-file "~/Dropbox/kanban/doc.txt"
		 (expand-file-name
		  (read-from-minibuffer "Rename: " `(".txt" . 1) nil nil nil)
		  "~/Dropbox/kanban")
		 1))
  (defun work-folder ()
    (interactive)
    (find-file "~/Documents/work"))
  (defun my/githubimage ()
    (interactive)
    (find-file "~/Pictures/image/")))
