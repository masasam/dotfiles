(when (window-system)
  ;; Hide splash at start
  (setq inhibit-startup-message t)
  ;; Change start screen with dashboard
  (require 'dashboard)
  ;; Set the title
  (setq dashboard-banner-logo-title (concat "GNU Emacs " emacs-version " kernel " (car (split-string (shell-command-to-string "uname -r") "-"))  " x86_64 ArchLinux GTK+ " gtk-version-string))
  ;; Set the banner
  (setq dashboard-startup-banner "~/Dropbox/emacs/emacs.png")
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents  . 15))))
