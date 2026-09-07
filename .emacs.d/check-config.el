;;; check-config.el --- Parse-check the Emacs configuration -*- lexical-binding: t; -*-

(let* ((config-directory
        (file-name-directory (or load-file-name buffer-file-name)))
       (files
        (cons (expand-file-name "init.el" config-directory)
              (directory-files-recursively
               (expand-file-name "inits" config-directory) "\\.el\\'"))))
  (dolist (file files)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (condition-case error-data
          (while t
            (read (current-buffer)))
        (end-of-file nil)
        (error
         (message "%s: %s" file (error-message-string error-data))
         (kill-emacs 1)))))
  (message "Emacs configuration checks passed (%d files)" (length files)))

;;; check-config.el ends here
