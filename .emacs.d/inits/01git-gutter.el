;; git-gutter
(global-git-gutter-mode t)

(custom-set-variables
 '(git-gutter:handled-backends '(git hg bzr)))

(require 'smartrep)
(smartrep-define-key
    global-map  "C-x" '(("p" . 'git-gutter:previous-hunk)
                        ("n" . 'git-gutter:next-hunk)))
