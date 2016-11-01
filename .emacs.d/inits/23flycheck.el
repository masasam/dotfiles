;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; fly-check-pos-tip
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))
