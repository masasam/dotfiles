;;; init.el --- myinit.el
;;; Commentary:
;;; Code:
(package-initialize)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(set-frame-parameter nil 'fullscreen 'maximized)

;; cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(setq load-prefer-newer t)
(require 'auto-compile)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

;; init-loader
(require 'init-loader)
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load)

;; Avoid to write `package-selected-packages` in init.el
(load (setq custom-file (expand-file-name "custom.el" user-emacs-directory)))

(provide 'init)
;;; init.el ends here
