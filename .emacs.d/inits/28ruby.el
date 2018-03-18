(require 'rbenv)
(setq rbenv-installation-dir "/home/masa/.rbenv")
(global-rbenv-mode)

(add-to-list 'auto-mode-alist
             '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))

(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)

;; robe
;;(autoload 'robe-mode "robe" "Code navigation, documentation lookup and completion for Ruby" t nil)

(eval-after-load 'company
  '(push 'company-robe company-backends))

(setq enh-ruby-add-encoding-comment-on-save nil)

;; rspec-mode
(eval-after-load 'rspec-mode
  '(rspec-install-snippets))

;; projectile rails
(projectile-rails-global-mode)
