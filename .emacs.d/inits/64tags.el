(add-hook 'python-mode-hook
	  (lambda ()
	    (ggtags-mode 1)))
(add-hook 'php-mode-hook
	  (lambda ()
	    (ggtags-mode 1)))
(add-hook 'enh-ruby-mode-hook
	  (lambda ()
	    (ggtags-mode 1)))

(when (require 'rtags nil 'noerror)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (if (rtags-is-indexed)
		  (progn
		    (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
		    (local-set-key (kbd "M-;") 'rtags-find-symbol)
		    (local-set-key (kbd "M-@") 'rtags-find-references)
		    (local-set-key (kbd "M-,") 'rtags-location-stack-back))
		(ggtags-mode 1)))))
