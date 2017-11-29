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
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-files-in-current-dir helm-source-recentf helm-source-projectile-files-list)))
 '(helm-truncate-lines t t)
 '(init-loader-show-log-after-init (quote error-only))
 '(package-selected-packages
   (quote
    (easy-jekyll yaml-mode which-key web-mode volatile-highlights use-package undo-tree twig-mode toml-mode tide tern-auto-complete sql-indent smartrep smartparens shell-pop ruby-electric realgud racer quickrun py-yapf py-autopep8 popwin pkgbuild-mode pcre2el paredit pangu-spacing org-plus-contrib nginx-mode material-theme markdown-mode magit key-chord jinja2-mode jedi japanese-holidays irony-eldoc init-loader inf-ruby indium iflipb httprepl helm-tramp helm-swoop helm-smex helm-pydoc helm-projectile helm-go-package helm-gitignore helm-ghq helm-directory helm-descbinds helm-chrome helm-c-yasnippet helm-ag goto-chg google-translate google-this go-projectile go-impl go-autocomplete git-timemachine git-gutter ggtags fuzzy flyspell-correct-popup flycheck-title flycheck-rust flycheck-package flycheck-irony flycheck-elixir expand-region exec-path-from-shell enh-ruby-mode elscreen elisp-slime-nav eldoc-extension editorconfig easy-hugo dockerfile-mode docker direx dashboard company-ansible color-theme-sanityinc-tomorrow cask browse-at-remote beginend auto-virtualenvwrapper auto-compile anzu anything-tramp ansible-doc ansible aggressive-indent ac-slime ac-php ac-alchemist)))
 '(shell-pop-default-directory "~")
 '(shell-pop-full-span t)
 '(shell-pop-shell-type
   (quote
    ("ansi-term" "*ansi-term*"
     (lambda nil
       (ansi-term shell-pop-term-shell)))))
 '(shell-pop-term-shell "/bin/zsh")
 '(shell-pop-universal-key "C-t")
 '(shell-pop-window-position "bottom")
 '(shell-pop-window-size 30))
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
