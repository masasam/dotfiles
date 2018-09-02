;; dired
(with-eval-after-load 'dired
  (bind-key "E" 'wdired-change-to-wdired-mode dired-mode-map)
  (bind-key "e" 'my-dired-ediff-files dired-mode-map))

(defun my-dired-ediff-files ()
  "Start ediff with a file marked with dired-mode."
  (interactive)
  (let ((files (dired-get-marked-files))
        (wnd (current-window-configuration)))
    (if (<= (length files) 2)
        (let ((file1 (car files))
	      (file2 (if (cdr files)
                         (cadr files)
		       (read-file-name
                        "file: "
                        (dired-dwim-target-directory)))))
          (if (file-newer-than-file-p file1 file2)
	      (ediff-files file2 file1)
            (ediff-files file1 file2))
          (add-hook 'ediff-after-quit-hook-internal
                    (lambda ()
		      (setq ediff-after-quit-hook-internal nil)
		      (set-window-configuration wnd))))
      (error "no more than 2 files should be marked"))))

(defun my/password ()
  (interactive)
  (find-file "~/Dropbox/passwd/pass.gpg"))

(defun kanban ()
  (interactive)
  (find-file "~/Dropbox/kanban/doc.txt"))

(defun kanban-rename ()
  (interactive)
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
  (find-file "~/Pictures/image/"))
