;; org
(require 'org)

(setq org-directory "~/Dropbox/emacs")
(setq org-default-notes-file "~/Dropbox/emacs/todo.org")
(setq org-agenda-files (list org-default-notes-file ))

(setq org-src-fontify-natively t)

;; DONEの時刻を記録
(setq org-log-done 'time)

(global-set-key (kbd "C-c a") 'org-agenda)
