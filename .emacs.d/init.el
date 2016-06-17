;;; init.el --- myinit.el
;;; Commentary:
;;; Code:
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
