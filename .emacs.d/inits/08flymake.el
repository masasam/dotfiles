;;; 08flymake.el --- 08flymake.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; flymake
(require 'flymake-diagnostic-at-point)
(with-eval-after-load 'flymake
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)
  (add-hook 'emacs-lisp-mode-hook #'package-lint-setup-flymake)
  (set-face-attribute 'popup-tip-face nil
		      :background "dark slate gray" :foreground "white" :underline nil))


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
;;; 08flymake.el ends here
