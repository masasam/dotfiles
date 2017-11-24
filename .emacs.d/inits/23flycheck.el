;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
;;flycheck-package
(eval-after-load 'flycheck
  '(flycheck-package-setup))
(with-eval-after-load 'flycheck
  (flycheck-title-mode))
