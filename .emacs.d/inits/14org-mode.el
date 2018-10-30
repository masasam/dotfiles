(require 'org)

(setq org-log-done 'time)
(setq org-use-speed-commands t)
(setq org-src-fontify-natively t)
(setq org-agenda-files '("~/Dropbox/emacs/org/task.org"))
(setq calendar-holidays nil)

(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(setq org-capture-templates
      '(("e" "Experiment" entry (file+headline "~/Dropbox/emacs/org/experiment.org" "Experiment")
	 "* %? %U %i\n")
	("i" "Idea" entry (file+headline "~/Dropbox/emacs/org/idea.org" "Idea")
	 "* %? %U %i")
	("r" "Remember" entry (file+headline "~/Dropbox/emacs/org/remember.org" "Remember")
	 "* %? %U %i")
	("m" "Memo" entry (file+headline "~/Dropbox/emacs/org/memo.org" "Memo")
	 "* %? %U %i")
	("s" "Story" entry (file+headline "~/Dropbox/emacs/org/story.org" "Story")
	 "* %? %U %i")
	("f" "Future Task" entry (file+headline "~/Dropbox/emacs/org/task_future.org" "Future Task")
	 "** TODO %? \n")
	("t" "Task" entry (file+headline "~/Dropbox/emacs/org/task.org" "Task")
	 "** TODO %? \n   SCHEDULED: %^t \n")
	("p" "Priority task" entry (file "~/Dropbox/emacs/org/priority_task.org")
         "* %?\n" :clock-in t :clock-resume t)))

(setq org-refile-targets
      (quote (("~/Dropbox/emacs/org/archives.org" :level . 1)
	      ("~/Dropbox/emacs/org/remember.org" :level . 1)
	      ("~/Dropbox/emacs/org/memo.org" :level . 1)
	      ("~/Dropbox/emacs/org/task.org" :level . 1))))
