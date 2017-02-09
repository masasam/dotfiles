;; magit
(autoload 'magit-status "magit" nil t)
(require 'bind-key)
(bind-key "C-x g" 'magit-status)

(add-hook 'git-commit-mode-hook 'flyspell-mode)
