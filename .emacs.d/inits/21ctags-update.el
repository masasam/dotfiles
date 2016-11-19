(setq ctags-update-command "/usr/bin/ctags")
;;; 使う言語で有効に
(add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'perl-mode-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'python-mode-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'ruby-mode-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'sh-mode-common-hook  'turn-on-ctags-auto-update-mode)
