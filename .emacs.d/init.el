;;; init.el --- init.el -*- lexical-binding: t; -*-
;;; Commentary:
;; URL: https://github.com/masasam/dotfiles
;;; Code:
;; Package-Requires: ((emacs "25.1"))
;;(setq debug-on-error t)

(set-frame-parameter nil 'alpha-background 85) ; For current frame
(add-to-list 'default-frame-alist '(alpha-background . 85)) ; For all new frames henceforth
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(set-frame-parameter nil 'fullscreen 'maximized)
(setq byte-compile-warnings '(cl-functions))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)


;; A workaround for a bug that occurs with gnutls 3.6 and emacs 26.1 emacs 26.2
(when (and (= emacs-major-version 26) (or (= emacs-minor-version 1) (= emacs-minor-version 2)))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))


;; Install only packages which are actually missing.  Checking the ELPA
;; directory itself misses partially installed packages and packages added to
;; this list after the first startup.
(let* ((required-packages
	'(ace-window aggressive-indent ast-grep auto-compile avy beginend
	  bind-key browse-at-remote cape catppuccin-theme consult consult-dir
	  consult-ghq copilot corfu csv-mode dashboard dmacro deadgrep difftastic
	  diff-hl dockerfile-mode dracula-theme dumb-jump easy-hugo easy-jekyll
	  edit-indirect editorconfig-generate eldoc-box elisp-slime-nav
	  embark embark-consult espy exec-path-from-shell expreg
	  fill-column-indicator flymake flymake-diagnostic-at-point ggtags
	  git-timemachine github-explorer github-review go-mode google-c-style
	  google-this google-translate gptel gptel-commit gt htmlize hydra iedit
	  init-loader js2-mode json-mode json-reformat key-chord keycast
	  keychain-environment macrostep magit marginalia markdown-mode
	  material-theme minions nginx-mode openwith orderless org package-lint
	  package-lint-flymake page-break-lines pass password-generator popper
	  posframe puni python-mode quickrun rake realgud realgud-byebug
	  apheleia restclient restclient-test rust-mode lua-ts-mode sly
	  smart-jump shackle symbol-overlay tldr toml-mode trashed tree-sitter
	  tree-sitter-langs verb vertico volatile-highlights
	  vundo web-mode yaml-mode yasnippet yasnippet-snippets zig-mode))
	(required-packages
	 (append required-packages
		 (when (< emacs-major-version 29) '(docker-tramp eglot))
		 (when (< emacs-major-version 27) '(editorconfig))))
	(missing-packages
	 (seq-remove #'package-installed-p required-packages)))
  (when missing-packages
    (package-refresh-contents)
    (dolist (package missing-packages)
      (package-install package))))

;; auto-compile
(setq load-prefer-newer t)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

;; Custom settings must be loaded explicitly when `custom-file' is non-nil.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;; init-loader
(setq init-loader-show-log-after-init 'error-only)
(init-loader-load)

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
