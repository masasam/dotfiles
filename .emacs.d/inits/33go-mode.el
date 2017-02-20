(require 'go-autocomplete)
(require 'auto-complete-config)
;; go-mode
(setenv "GOPATH" "/home/masa")
(add-to-list 'exec-path (expand-file-name "~/bin"))

;; eldoc
(require 'go-eldoc)
(add-hook 'go-mode-hook 'go-eldoc-setup)

;; gofmt goimports
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(add-hook 'go-mode-hook
          '(lambda()
             (setq c-basic-offset 4)
             (setq indent-tabs-mode t)
             (local-set-key (kbd "M-.") 'godef-jump)
             (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
             (local-set-key (kbd "C-c a") 'go-import-add)
             (local-set-key (kbd "C-c d") 'godoc)))
