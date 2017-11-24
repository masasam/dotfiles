;; biginend
(beginend-global-mode)

;; helm-ghq
(bind-key "C-x l" 'helm-ghq)
(bind-key "C-x C-l" 'helm-ghq)

;; goto-chg
(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)
