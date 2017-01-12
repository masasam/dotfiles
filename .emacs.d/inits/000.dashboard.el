;; スタート時のスプラッシュ非表示
(setq inhibit-startup-message t)
;; 起動画面をdashboardで変更
(require 'dashboard)
;; Set the title
(setq dashboard-banner-logo-title emacs-version)
;; Set the banner
(setq dashboard-startup-banner "~/Dropbox/emacs/emacs.png")
(dashboard-setup-startup-hook)
(setq dashboard-items '((recents  . 20)))
