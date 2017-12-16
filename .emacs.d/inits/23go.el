;; go-mode
(with-eval-after-load 'go-mode
  (require 'go-projectile)
  (require 'company-go)

  (add-hook 'go-mode-hook
	    '(lambda()
	       (set (make-local-variable 'company-backends) '(company-go))
	       (setq gofmt-command "goimports")
	       (add-hook 'before-save-hook 'gofmt-before-save)
	       (setq c-basic-offset 4)
	       (setq indent-tabs-mode t)
	       (local-set-key (kbd "M-.") 'godef-jump)
	       (go-eldoc-setup))))
