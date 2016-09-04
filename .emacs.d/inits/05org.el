;; org
(require 'org)

(setq org-directory "~/Documents/junk")
(setq org-agenda-files (list org-directory))

(setq org-src-fontify-natively t)

;; DONEの時刻を記録
(setq org-log-done 'time)
