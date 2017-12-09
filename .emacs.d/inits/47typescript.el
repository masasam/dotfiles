(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode t)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode t)
            (company-mode-on)
	    (auto-compile-mode -1)
	    (add-hook 'before-save-hook 'tide-format-before-save)))
