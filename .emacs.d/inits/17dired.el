;;; 17dired.el --- 17dired.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun dired-full-path ()
  (interactive)
  (kill-new default-directory))

(defun dired-parent-directory ()
  (interactive)
  (kill-new (car (cdr (reverse (split-string default-directory "/"))))))

(defun dired-show-directory ()
  (interactive)
  (message default-directory))

;; Dired files deleted by trash and no ask recursive
(setq delete-by-moving-to-trash t
      dired-recursive-copies 'always
      dired-recursive-deletes 'always)

;; dired
(with-eval-after-load 'dired
  (bind-key "e" 'my-dired-ediff-files dired-mode-map))

(defun dired-dwim-target-directory ()
  "Try to guess which target directory the user may want.
If there is a dired buffer displayed in one of the next windows,
use its current subdir, else use current subdir of this dired buffer."
  (let ((this-dir (and (eq major-mode 'dired-mode)
		       (dired-current-directory))))
    ;; non-dired buffer may want to profit from this function, e.g. vm-uudecode
    (if dired-dwim-target
	(let* ((other-win (get-window-with-predicate
			   (lambda (window)
			     (with-current-buffer (window-buffer window)
			       (eq major-mode 'dired-mode)))
			   nil
			   'visible))
	       (other-dir (and other-win
			       (with-current-buffer (window-buffer other-win)
				 (and (eq major-mode 'dired-mode)
				      (dired-current-directory))))))
	  (or other-dir this-dir))
      this-dir)))

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

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 17dired.el ends here
