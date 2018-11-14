;; expand-region
(require 'expand-region)
(push 'er/mark-outside-pairs er/try-expand-list)
(bind-key "C-M-SPC" 'er/expand-region)


;; avy
(bind-key "C-r" 'avy-goto-char-2)


;; back-button
(back-button-mode 1)


;; begin-end
(beginend-global-mode)


;; goto-chg
(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)


;; editorconfig
(editorconfig-mode 1)
(setq editorconfig-get-properties-function
      'editorconfig-core-get-properties-hash)


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


;; dumb-jump
(dumb-jump-mode)
(setq dumb-jump-selector 'ivy)


;; yesnippet
(require 'yasnippet)
(yas-global-mode 1)


;; projectile
(projectile-mode)
(counsel-projectile-mode)

;; How to clear cache (M-x projectile-invalidate-cache)
(setq projectile-enable-caching t)
;; require ggtags
(setq projectile-tags-file-name "GTAGS")
(setq projectile-tags-command "gtags")


;; ggtags
;; (add-hook 'php-mode-hook 'ggtag-setting)
;; ;;(add-hook 'enh-ruby-mode-hook 'ggtag-setting)
;; (add-hook 'c-mode-common-hook 'ggtag-setting)
;; (add-hook 'js2-mode-hook 'ggtag-setting)
;; (add-hook 'js2-jsx-mode-hook 'ggtag-setting)
(defun ggtag-setting ()
  (ggtags-mode 1))


;; eldoc
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)


;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;;flycheck-package
(eval-after-load 'flycheck
  '(flycheck-package-setup))
(with-eval-after-load 'flycheck
  (flycheck-title-mode))


;; flyspell-correct
(require 'flyspell-correct-ivy)
(define-key flyspell-mode-map (kbd "C-M-;") #'flyspell-correct-previous-word-generic)


;; smartparens
(require 'smartparens-config)
(smartparens-global-mode t)
(add-hook 'emacs-lisp-mode-hook 'turn-off-smartparens-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-off-smartparens-mode)
(add-hook 'lisp-mode-hook 'turn-off-smartparens-mode)
(add-hook 'ielm-mode-hook 'turn-off-smartparens-mode)
(add-hook 'scheme-mode-hook 'turn-off-smartparens-mode)
(add-hook 'slime-repl-mode-hook 'turn-off-smartparens-mode)


;; Fill-Column-Indicator
(setq fci-rule-column 80)
(setq fci-rule-width 3)
(setq fci-rule-color "sea green")


;; alarm-clock
(setq alarm-clock-sound-file "~/Dropbox/emacs/alarm.mp3")
