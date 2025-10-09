;;; 01dashboard.el --- 01dashboard.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(when (window-system)
  ;; Hide splash at start
  (setq inhibit-startup-message t)
  ;; Change start screen with dashboard
  (require 'dashboard)
  ;; Set the title
  (setq dashboard-banner-logo-title
	(concat "GNU Emacs " emacs-version " kernel "
		(car (split-string (shell-command-to-string "uname -r") "-"))
		" x86_64 ArchLinux Hyprland " (car (cdr (split-string (shell-command-to-string "hyprland --version") " ")))))
  ;; Set the banner
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents   . 5)))
  (dashboard-setup-startup-hook)
  (global-page-break-lines-mode)
  (setq dashboard-page-separator "\n\f\f\n"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 01dashboard.el ends here
