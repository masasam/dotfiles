(add-hook 'yaml-mode-hook
          (lambda ()
	    (ansible 1)
            (company-mode 1)
	    (auto-complete-mode -1)
	    (add-to-list 'company-backends 'company-ansible)))

(setq ansible::vault-password-file "~/Dropbox/ansible/vault_pass")
(add-hook 'ansible-hook 'ansible::auto-decrypt-encrypt)

;; ansible-doc
(add-hook 'yaml-mode-hook #'ansible-doc-mode)
