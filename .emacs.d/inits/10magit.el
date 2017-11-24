;; magit
(autoload 'magit-status "magit" nil t)
(bind-key "C-x g" 'magit-status)

(add-hook 'git-commit-mode-hook 'flyspell-mode)
