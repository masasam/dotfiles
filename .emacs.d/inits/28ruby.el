;;; 28ruby.el --- 28ruby.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq ruby-insert-encoding-magic-comment nil)

(add-hook 'ruby-mode-hook 'eglot-ensure)

;; projectile rails
(projectile-rails-global-mode)

;; (add-to-list 'auto-mode-alist
;;              '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))
;; (setq enh-ruby-add-encoding-comment-on-save nil)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 28ruby.el ends here
