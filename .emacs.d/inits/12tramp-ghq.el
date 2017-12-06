(setq tramp-default-method "ssh")
(defalias 'exit-tramp 'tramp-cleanup-all-buffers)
(define-key global-map (kbd "C-c s") 'counsel-tramp)
(setq counsel-tramp-docker-user "username")
(setq counsel-tramp-docker-user '("username1" "username2" "username3" "username4"))

;; counsel-ghq
(bind-key "C-x l" 'counsel-ghq)
(bind-key "C-x C-l" 'counsel-ghq)

(defun counsel-ghq--list-candidates ()
  (with-temp-buffer
    (unless (zerop (apply #'call-process
			  "ghq" nil t nil
			  '("list" "--full-path")))
      (error "Failed: Can't get ghq list candidates"))
    (let ((paths))
      (goto-char (point-min))
      (while (not (eobp))
	(push (buffer-substring-no-properties
	       (line-beginning-position) (line-end-position)) paths)
        (forward-line 1))
      (reverse paths))))

(defun counsel-ghq ()
  (interactive)
  (counsel-find-file (ivy-read "ghq list: " (counsel-ghq--list-candidates))))
