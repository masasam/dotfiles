;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;;flycheck-package
(eval-after-load 'flycheck
  '(flycheck-package-setup))
