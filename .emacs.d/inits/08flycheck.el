;;; 08flychekc.el --- 08flycheck.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; flymake
(eval-after-load 'flymake
  (require 'flymake-diagnostic-at-point)
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)
  (set-face-attribute 'popup-tip-face nil
		      :background "dark slate gray" :foreground "cyan1" :underline nil))


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
(define-key flyspell-mode-map (kbd "C-;") #'counsel-switch-buffer)
;; (add-hook 'prog-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'flyspell-mode)


;; smartparens
(require 'smartparens-config)
(smartparens-global-mode t)
(add-hook 'emacs-lisp-mode-hook 'turn-off-smartparens-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-off-smartparens-mode)
(add-hook 'lisp-mode-hook 'turn-off-smartparens-mode)
(add-hook 'ielm-mode-hook 'turn-off-smartparens-mode)
(add-hook 'scheme-mode-hook 'turn-off-smartparens-mode)
(add-hook 'slime-repl-mode-hook 'turn-off-smartparens-mode)


;; eldoc
(setq eldoc-idle-delay 0.50)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 08flycheck.el ends here
