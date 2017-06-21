(add-to-list 'auto-mode-alist '("\\.volt\\'" . twig-mode))
(add-hook 'twig-mode-hook
	  '(lambda ()
	     (auto-complete-mode t)
	     (yas-global-mode 1)))
