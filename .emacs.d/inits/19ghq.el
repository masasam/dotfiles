(add-to-list 'helm-for-files-preferred-list 'helm-source-ghq)
;; C-x l , C-x C-lをhelm-ghq
(global-set-key (kbd "C-x l") 'helm-ghq)
(global-set-key (kbd "C-x C-l") 'helm-ghq)
