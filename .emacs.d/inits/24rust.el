;;; 24rust.el --- 24rust.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'rust-mode
  (setq-default rust-format-on-save t))
;; Launch racer and flycheck when editing rust files
(add-hook 'rust-mode-hook (lambda ()
                            (racer-mode)
                            (flycheck-rust-setup)))
;; Use racer's eldoc support
(add-hook 'racer-mode-hook #'eldoc-mode)
;; Use racer's supplementary support
(add-hook 'racer-mode-hook (lambda ()
                             (company-mode-on)
                             (set (make-variable-buffer-local 'company-idle-delay) 0.1)
                             (set (make-variable-buffer-local 'company-minimum-prefix-length) 1)))

;;; 24rust.el ends here
