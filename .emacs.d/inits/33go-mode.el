;; go-mode
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

(autoload 'helm-go-package "helm-go-package")
(eval-after-load 'go-mode
  '(substitute-key-definition 'go-import-add 'helm-go-package go-mode-map))
