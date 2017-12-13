(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(bind-key "C-s" 'swiper)
(bind-key "C-;" 'ivy-switch-buffer)
(bind-key "C-c r" 'ivy-resume)
(bind-key "C-x C-c" 'counsel-M-x)
(bind-key "M-x" 'counsel-M-x)
(bind-key "C-x C-f" 'counsel-find-file)
(bind-key "M-y" 'counsel-yank-pop)
(bind-key "C-x m" 'counsel-mark-ring)
(bind-key "C-x F" 'counsel-describe-function)
(bind-key "C-x V" 'counsel-describe-variable)
(bind-key "C-x L" 'counsel-find-library)
(bind-key "C-x I" 'counsel-info-lookup-symbol)
(bind-key "C-x U" 'counsel-unicode-char)
(bind-key "C-c g" 'counsel-git)
(bind-key "C-c j" 'counsel-git-grep)
(bind-key "C-c k" 'counsel-ag)
(bind-key "C-c l" 'counsel-locate)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
(setq ivy-use-virtual-buffers t)
(require 'ivy-xref)
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
(defun swiper-for-region ()
  (interactive)
  (swiper--ivy
   (cl-remove-if-not
    (lambda (x)
      (string-match (buffer-substring
		     (region-beginning) (region-end)) x))
    (swiper--candidates))))


;; counsel-tramp
(setq tramp-default-method "ssh")
(defalias 'quit-tramp 'tramp-cleanup-all-buffers)
(define-key global-map (kbd "C-c s") 'counsel-tramp)


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
