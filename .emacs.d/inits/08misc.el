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
(setq
 ediff-window-setup-function 'ediff-setup-windows-plain
 ediff-split-window-function 'split-window-horizontally
 ediff-diff-options "-twB")


;; volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)


;; quickrun
(bind-key "<f5>" 'quickrun)


;; pcre
(require 'pcre2el)
(add-hook 'prog-mode-hook 'rxt-mode)
(setq reb-re-syntax 'pcre)


;; docker-tramp
(require 'docker-tramp-compat)


;; dumb-jump
(dumb-jump-mode)
(setq dumb-jump-selector 'ivy)
