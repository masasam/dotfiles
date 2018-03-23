(require 'org)

(setq org-directory "~/Dropbox/emacs")
(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(setq org-capture-templates
      '(("m" "Memo" entry (file+headline "~/Dropbox/emacs/org/memo.org" "Memo")
	 "* %? %U %i")
	("n" "Note" entry (file+headline "~/Dropbox/emacs/org/notes.org" "Notes")
	 "* %? %U %i")))

;; Open org-note
(defun notes ()
  (interactive)
  (find-file "~/Dropbox/emacs/org/notes.org"))

(defun memo ()
  (interactive)
  (find-file "~/Dropbox/emacs/org/memo.org"))

(smartrep-define-key org-mode-map "C-c"
  '(("C-n" . org-next-visible-heading)
    ("C-p" . org-previous-visible-heading)
    ("C-u" . outline-up-heading)
    ("C-f" . org-forward-heading-same-level)
    ("C-b" . org-backward-heading-same-level)))
