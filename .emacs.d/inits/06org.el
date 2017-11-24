(require 'org)

(unless (member "CLOCK" org-special-properties)
  (defun org-get-CLOCK-property (&optional pom)
    (org-with-wide-buffer
     (org-with-point-at pom
       (when (and (derived-mode-p 'org-mode)
		  (ignore-errors (org-back-to-heading t))
		  (search-forward org-clock-string
				  (save-excursion (outline-next-heading) (point))
				  t))
	 (skip-chars-forward " ")
	 (cons "CLOCK"  (buffer-substring-no-properties (point) (point-at-eol)))))))
  (defadvice org-entry-properties (after with-CLOCK activate)
    "org"
    (let ((it (org-get-CLOCK-property (ad-get-arg 0))))
      (setq ad-return-value
            (if it
                (cons it ad-return-value)
              ad-return-value)))))

(setq org-agenda-start-with-log-mode t)
(setq org-agenda-span 30)
(setq org-agenda-files '("~/Dropbox/emacs/org/inbox.org" "~/Dropbox/emacs/org/daily-projects.org"))
(setq org-agenda-custom-commands
      '(("a" "Agenda and all TODO's"
         ((tags "project-CLOCK=>\"<today>\"|repeatable") (agenda "") (alltodo)))))


(setq org-directory "~/Dropbox/emacs")
(setq org-default-notes-file "~/Dropbox/emacs/org/daily-projects.org")
(bind-key "C-c a" 'org-agenda)
(bind-key "C-c c" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/emacs/org/daily-projects.org" "Tasks")
	 "* TODO %? %i %a")
        ("n" "Note" entry (file+headline "~/Dropbox/emacs/org/notes.org" "Notes")
	 "* %? %U %i")
	("i" "interrupted task" entry
         (file "~/Dropbox/emacs/org/daily-projects.org")
         "* %?" :clock-in t :clock-resume t)
	))

;; Open org-note
(defun notes ()
  (interactive)
  (find-file "~/Dropbox/emacs/org/notes.org"))

(defun inbox ()
  (interactive)
  (find-file "~/Dropbox/emacs/org/inbox.org"))


(require 'smartrep)
(smartrep-define-key org-mode-map "C-c"
  '(("C-n" . org-next-visible-heading)
    ("C-p" . org-previous-visible-heading)
    ("C-u" . outline-up-heading)
    ("C-f" . org-forward-heading-same-level)
    ("C-b" . org-backward-heading-same-level)))

(setq org-src-fontify-natively t)

(with-eval-after-load "calendar"
  (require 'japanese-holidays)
  (setq calendar-holidays ;Adjust appropriately if you want to display holidays in other countries as well
        (append japanese-holidays holiday-local-holidays holiday-other-holidays))
  (setq calendar-mark-holidays-flag t)    ;Display holidays on the calendar
  ;; To display Saturdays and Sundays as a holiday, add the following settings.
  (setq japanese-holiday-weekend '(0 6)    ;Saturday and Sunday as a holiday
        japanese-holiday-weekend-marker    ;Saturday in light blue
        '(holiday nil nil nil nil nil japanese-holiday-saturday))
  (add-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
  (add-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)
  ;; To mark "Today", add the following settings.
  (add-hook 'calendar-today-visible-hook 'calendar-mark-today)
  ;; Display holidays with org-agenda
  (setq org-agenda-include-diary t))
