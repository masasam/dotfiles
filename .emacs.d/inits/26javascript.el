(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\.jsx$" . js2-jsx-mode))
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
