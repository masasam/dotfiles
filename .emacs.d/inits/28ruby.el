;;; 28ruby.el --- 28ruby.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package ruby-ts-mode
  :hook
  (ruby-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  (projectile-rails-global-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 28ruby.el ends here
