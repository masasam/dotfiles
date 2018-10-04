(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\.jsx$" . js2-jsx-mode))
(require 'flycheck)
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)

(add-hook 'js2-mode-hook
          (lambda ()
	    (setq tern-command '("tern" "--no-port-file"))
            (tern-mode t)))

(add-hook 'js2-jsx-mode-hook
          (lambda ()
	    (setq tern-command '("tern" "--no-port-file"))
            (tern-mode t)))

(add-to-list 'company-backends 'company-tern)


;; xref-js2
(define-key js2-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
			   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))


;; typescript
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode t)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode t)
            (company-mode-on)
	    (auto-compile-mode -1)
	    (add-hook 'before-save-hook 'tide-format-before-save)))


;; coffeescript
(custom-set-variables
 '(coffee-tab-width 2)
 '(coffee-args-compile '("-c" "--no-header" "--bare")))

(eval-after-load "coffee-mode"
  '(progn
     (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer)
     (define-key coffee-mode-map (kbd "C-j") 'coffee-newline-and-indent)))
