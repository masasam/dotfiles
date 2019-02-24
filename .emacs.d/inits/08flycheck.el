;;; 08flychekc.el --- 08flycheck.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

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
(define-key flyspell-mode-map (kbd "C-;") #'ivy-switch-buffer)
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
(setq eldoc-idle-delay 0)
(setq eldoc-echo-area-use-multiline-p t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 08flycheck.el ends here
