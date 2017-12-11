(setq
 shell-pop-default-directory "~"
 shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell))))
 shell-pop-term-shell "/bin/zsh"
 shell-pop-universal-key "C-t"
 shell-pop-window-size 30
 shell-pop-full-span t
 shell-pop-window-position "bottom")

;; eshell
(add-to-list 'eshell-command-aliases-list (list "ll" "ls -la"))
(add-to-list 'eshell-command-aliases-list (list "la" "ls -A"))
