;; go-mode
(eval-after-load "go-mode"
  '(progn
     (require 'go-projectile)
     (require 'go-autocomplete)

     (add-hook 'go-mode-hook
	       '(lambda()
		  (setq gofmt-command "goimports")
		  (add-hook 'before-save-hook 'gofmt-before-save)
		  (setq c-basic-offset 4)
		  (setq indent-tabs-mode t)
		  (local-set-key (kbd "M-.") 'godef-jump)
		  (go-eldoc-setup)))

     (substitute-key-definition 'go-import-add 'helm-go-package go-mode-map)
     (autoload 'helm-go-package "helm-go-package")))
