(require 'org)

(setq org-directory "~/Dropbox/emacs")
(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(setq org-capture-templates
      '(("i" "Idea" entry (file+headline "~/Dropbox/emacs/org/idea.org" "Idea")
	 "* %? %U %i")
	("m" "Memo" entry (file+headline "~/Dropbox/emacs/org/memo.org" "Memo")
	 "* %? %U %i")))

(smartrep-define-key org-mode-map "C-c"
  '(("C-n" . org-next-visible-heading)
    ("C-p" . org-previous-visible-heading)
    ("C-u" . outline-up-heading)
    ("C-f" . org-forward-heading-same-level)
    ("C-b" . org-backward-heading-same-level)))
