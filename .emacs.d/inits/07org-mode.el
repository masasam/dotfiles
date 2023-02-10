;;; 07org-mode.el --- 07org-mode.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'org)
(require 'org-tempo)

(setq org-log-done 'time)
(setq org-use-speed-commands t)
(setq org-src-tab-acts-natively t)
(setq org-src-fontify-natively t)
(setq org-agenda-files '("~/backup/emacs/org/task.org"))
(setq calendar-holidays nil)
(setq org-clock-clocked-in-display 'frame-title)

(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(with-eval-after-load "org"
  (define-key org-mode-map (kbd "C-'") #'hydra-pinky/body))

(setq org-capture-templates
      '(("e" "Experiment" entry (file+headline "~/backup/emacs/org/experiment.org" "Experiment")
	 "* %? %U %i\n
#+BEGIN_SRC emacs-lisp

#+END_SRC")
	("i" "Idea" entry (file+headline "~/backup/emacs/org/idea.org" "Idea")
	 "* %? %U %i")
	("r" "Remember" entry (file+headline "~/backup/emacs/org/remember.org" "Remember")
	 "* %? %U %i")
	("m" "Memo" entry (file+headline "~/backup/emacs/org/memo.org" "Memo")
	 "* %? %U %i")
	("t" "Task" entry (file+headline "~/backup/emacs/org/task.org" "Task")
	 "** TODO %? \n   SCHEDULED: %^t \n")))

(setq org-refile-targets
      (quote (("~/backup/emacs/org/archives.org" :level . 1)
	      ("~/backup/emacs/org/remember.org" :level . 1)
	      ("~/backup/emacs/org/memo.org" :level . 1)
	      ("~/backup/emacs/org/task.org" :level . 1))))

(defun kanban-rename ()
  "Rotate kanban file."
  (interactive)
  (rename-file "~/backup/kanban/kanban.org"
	       (expand-file-name
		(read-from-minibuffer "Rename: " `(".org" . 1) nil nil nil)
		"~/backup/kanban")
	       1))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 07org-mode.el ends here
