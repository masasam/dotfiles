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
