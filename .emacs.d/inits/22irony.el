;;; 22irony.el --- 22irony.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun my-irony-mode-on ()
  "Avoid enabling `irony-mode' in modes that inherits `c-mode', e.g: `php-mode'."
  (when (member major-mode irony-supported-major-modes)
    (irony-mode 1)))

(add-hook 'c-mode-hook 'my-irony-mode-on)
(add-hook 'c++-mode-hook 'my-irony-mode-on)
(add-hook 'objc-mode-hook 'my-irony-mode-on)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(add-to-list 'company-backends 'company-irony)
(add-hook 'irony-mode-hook #'irony-eldoc)


;; rtags
(when (require 'rtags nil 'noerror)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (rtags-is-indexed)
                (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
                (local-set-key (kbd "M-;") 'rtags-find-symbol)
                (local-set-key (kbd "M-@") 'rtags-find-references)
                (local-set-key (kbd "M-,") 'rtags-location-stack-back)))))

;;; 22irony.el ends here
