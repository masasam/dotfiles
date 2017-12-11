(add-hook 'php-mode-hook
          '(lambda ()
             (require 'company-php)
	     (local-set-key (kbd "<f1>") 'my-php-symbol-lookup)
             (company-mode t)
             (ac-php-core-eldoc-setup) ;; enable eldoc
             (make-local-variable 'company-backends)
             (add-to-list 'company-backends 'company-ac-php-backend)))
(add-hook 'php-mode-hook 'php-enable-psr2-coding-style)

(defun my-php-symbol-lookup ()
  (interactive)
  (let ((symbol (symbol-at-point)))
    (if (not symbol)
        (message "No symbol at point.")
      (browse-url (concat "http://php.net/manual-lookup.php?pattern="
                          (symbol-name symbol))))))
