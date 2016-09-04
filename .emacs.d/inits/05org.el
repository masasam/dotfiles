;; org
(require 'org)

(setq org-directory "~/Dropbox/emacs")
(setq org-default-notes-file "~/Dropbox/emacs/todo.org")
(setq org-agenda-files (list org-default-notes-file ))

(setq org-src-fontify-natively t)

;; DONEの時刻を記録
(setq org-log-done 'time)

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/emacs/todo.org" "Tasks")
             "* TODO %? %i %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/emacs/journal.org")
             "* %? %U %i %a")
        ("n" "Note" entry (file+headline "~/Dropbox/emacs/notes.org" "Notes")
	 "* %? %U %i")
	("i" "interrupted task" entry
         (file "~/Dropbox/emacs/todo.org")
         "* %?" :clock-in t :clock-resume t)
         ))
