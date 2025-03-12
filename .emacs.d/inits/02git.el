;;; 02git.el --- 02git.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; magit
(autoload 'magit-status "magit" nil t)
(bind-key "C-x g" 'magit-status)
(bind-key "C-x G" 'magit-blame)
(setq magit-show-long-lines-warning nil)

;; keychain-environment
(keychain-refresh-environment)


;; diff-hl
(global-diff-hl-mode)
(diff-hl-margin-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;;; 02git.el ends here
