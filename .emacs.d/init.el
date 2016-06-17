;;; init.el --- myinit.el
;;; Commentary:
;;; Code:
(set-frame-parameter nil 'fullscreen 'maximized)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(package-initialize)

;; cask
(require 'cask "/usr/share/cask/cask.el")
(cask-initialize)

;; init-loader
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load "~/.emacs.d/inits")

(provide 'init)
;;; init.el ends here
