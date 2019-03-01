;;; 17dired.el --- 17dired.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; Dired files deleted by trash and no ask recursive
(setq delete-by-moving-to-trash t
      dired-recursive-copies 'always
      dired-recursive-deletes 'always)

;; dired
(with-eval-after-load 'dired
  (bind-key "e" 'my-dired-ediff-files dired-mode-map))

(defun my-dired-ediff-files ()
  "Start ediff with a file marked with `dired-mode'."
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
      (error "No more than 2 files should be marked"))))


(defun kanban-rename ()
  "Rotate kanban file."
  (interactive)
  (rename-file "~/Dropbox/kanban/kanban"
	       (expand-file-name
		(read-from-minibuffer "Rename: " `(".txt" . 1) nil nil nil)
		"~/Dropbox/kanban")
	       1))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 17dired.el ends here
