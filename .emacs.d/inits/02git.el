;;; 02git.el --- 02git.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package magit
  :init
  ;; Magit's refresh path reads `hi-lock-mode' before hi-lock is autoloaded.
  (require 'hi-lock)
  :config
  (require 'magit-extras)
  :bind
  (("C-x g" . magit-status)
   ("C-x G" . magit-blame)))

;; keychain-environment
(keychain-refresh-environment)


(use-package diff-hl
  :init
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-margin-mode))


(use-package difftastic
  :config
  (difftastic-bindings-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 02git.el ends here
