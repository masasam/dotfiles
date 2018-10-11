(require 'org)

(setq org-directory "~/Dropbox/emacs/org")
(setq org-log-done 'time)
(setq org-use-speed-commands t)
(setq org-src-fontify-natively t)
(setq org-agenda-files '("~/Dropbox/emacs/org/task.org"))

(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(setq org-capture-templates
      '(("i" "Idea" entry (file+headline "~/Dropbox/emacs/org/idea.org" "Idea")
	 "* %? %U %i")
	("m" "Memo" entry (file+headline "~/Dropbox/emacs/org/memo.org" "Memo")
	 "* %? %U %i")
	("s" "Story" entry (file+headline "~/Dropbox/emacs/org/story.org" "Story")
	 "* %? %U %i")
	("f" "Future Task" entry (file+headline "~/Dropbox/emacs/org/future_task.org" "Future Task")
	 "** TODO %? \n")
	("t" "Task" entry (file+headline "~/Dropbox/emacs/org/task.org" "Task")
	 "** TODO %? \n   SCHEDULED: %^t \n")
	("p" "Priority task" entry (file "~/Dropbox/emacs/org/priority_task.org")
         "* %?\n" :clock-in t :clock-resume t)))

(setq org-refile-targets
      (quote (("~/Dropbox/emacs/org/task.org" :level . 1)
              ("~/Dropbox/emacs/org/future_task.org" :level . 1))))

(smartrep-define-key org-mode-map "C-c"
  '(("C-n" . org-next-visible-heading)
    ("C-p" . org-previous-visible-heading)
    ("C-u" . outline-up-heading)
    ("C-f" . org-forward-heading-same-level)
    ("C-b" . org-backward-heading-same-level)))
