;; スタート時のスプラッシュ非表示
(setq inhibit-startup-message t)
;; 起動画面をdashboardで変更
(require 'dashboard)
;; Set the title
(setq dashboard-banner-logo-title (concat "GNU Emacs " emacs-version " x86_64-Archlinux-gnu GTK+ Version " gtk-version-string))
;; Set the banner
(setq dashboard-startup-banner "~/Dropbox/emacs/emacs.png")
(dashboard-setup-startup-hook)
(setq dashboard-items '((recents  . 20)))
