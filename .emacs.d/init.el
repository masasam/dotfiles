;;; init.el --- myinit.el
;;; Commentary:
;;; Code:
(set-frame-parameter nil 'fullscreen 'maximized)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(setq load-prefer-newer t)
(package-initialize)
(require 'auto-compile)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

;; cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; init-loader
(require 'init-loader)
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load)

(provide 'init)
;;; init.el ends here
