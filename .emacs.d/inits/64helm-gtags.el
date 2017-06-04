;; customize
(custom-set-variables
 '(helm-gtags-path-style 'relative)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-auto-update t))

(add-hook 'helm-gtags-mode-hook
	  '(lambda ()
	     (local-set-key (kbd "M-.") 'helm-gtags-find-tag)
	     (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
	     (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
	     (local-set-key (kbd "M-l") 'helm-gtags-select)
	     (local-set-key (kbd "M-,") 'helm-gtags-pop-stack)))
(add-hook 'php-mode-hook 'helm-gtags-mode)
