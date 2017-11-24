;; expand-region
(require 'expand-region)
(push 'er/mark-outside-pairs er/try-expand-list)
(bind-key "C-M-SPC" 'er/expand-region)


;; biginend
(beginend-global-mode)


;; goto-chg
(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)


;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode t)


;; editorconfig
(editorconfig-mode 1)


;; ediff
(custom-set-variables
 '(ediff-window-setup-function 'ediff-setup-windows-plain)
 '(ediff-split-window-function 'split-window-horizontally)
 '(ediff-diff-options "-twB"))


;; anzu
(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
(custom-set-variables
 '(anzu-mode-lighter "")
 '(anzu-deactivate-region t)
 '(anzu-use-migemo nil)
 '(anzu-search-threshold 1000))


;; volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)


;; google-this
(bind-key "C-c g" 'google-this)


;; key-chord
(require 'key-chord)
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)
(key-chord-define-global "jk" 'view-mode)
