;; magit
(autoload 'magit-status "magit" nil t)
(bind-key "C-x g" 'magit-status)


;; git-gutter
(global-git-gutter-mode t)
(require 'smartrep)
(smartrep-define-key
    global-map  "C-x" '(("p" . 'git-gutter:previous-hunk)
			("n" . 'git-gutter:next-hunk)))
