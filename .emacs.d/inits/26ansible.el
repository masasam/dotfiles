(add-hook 'yaml-mode-hook '(lambda () (ansible 1)))
(setq ansible::vault-password-file "~/Dropbox/ansible/vault_pass")
(add-hook 'ansible-hook 'ansible::auto-decrypt-encrypt)

;; ansible-doc
(add-hook 'yaml-mode-hook #'ansible-doc-mode)
