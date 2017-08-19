(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-search-threshold 1000)
 '(anzu-use-migemo nil)
 '(ediff-diff-options "-twB")
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(git-gutter:handled-backends (quote (git hg bzr)))
 '(helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
 '(helm-ag-command-option "--all-text")
 '(helm-ag-insert-at-point (quote symbol))
 '(helm-delete-minibuffer-contents-from-point t)
 '(helm-gtags-auto-update t)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-path-style (quote relative))
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-files-in-current-dir helm-source-recentf helm-source-projectile-files-list)))
 '(helm-truncate-lines t t)
 '(init-loader-show-log-after-init (quote error-only))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(package-selected-packages
   (quote
    (ht zop-to-char yaml-mode which-key web-mode volatile-highlights undo-tree twig-mode toml-mode tide tern-auto-complete sql-indent smartrep smartparens realgud racer quickrun py-autopep8 popwin pkgbuild-mode php-eldoc phalcon pcre2el pangu-spacing org-plus-contrib nginx-mode material-theme markdown-mode magit key-chord js2-mode jinja2-mode jedi japanese-holidays init-loader iflipb helm-tramp helm-swoop helm-pydoc helm-projectile helm-gtags helm-go-package helm-gitignore helm-ghq helm-directory helm-descbinds helm-chrome helm-c-yasnippet helm-ag goto-chg google-translate google-this go-projectile go-impl go-autocomplete git-timemachine git-gutter git-complete ggtags fuzzy flyspell-correct flycheck-title flycheck-rust flycheck-package flycheck-irony flycheck-elixir flycheck-cask expand-region exec-path-from-shell elscreen elisp-slime-nav eldoc-extension editorconfig easy-hugo dockerfile-mode docker direx dashboard cliphist cask browse-at-remote bind-key auto-virtualenvwrapper auto-compile anzu anything-tramp ansible-doc ansible aggressive-indent ac-slime ac-php ac-alchemist))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "#82c600"))))
 '(elscreen-tab-background-face ((t (:background "#37474f"))))
 '(elscreen-tab-current-screen-face ((t (:background "LightSkyBlue4" :foreground "white"))))
 '(elscreen-tab-other-screen-face ((t (:background "#37474f" :foreground "Gray50"))))
 '(fixed-pitch ((t (:family "Ricty"))))
 '(helm-candidate-number ((t (:background "#1c1f26" :foreground "#ffffff"))))
 '(helm-ff-prefix ((t (:foreground "#82c600"))))
 '(helm-header-line-left-margin ((t (:foreground "#82c600"))))
 '(variable-pitch ((t (:family "Ricty")))))
