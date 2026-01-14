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


(use-package diff-hl
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-margin-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 02git.el ends here
