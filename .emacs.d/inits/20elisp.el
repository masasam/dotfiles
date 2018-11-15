;;; 20elisp.el --- 20elisp.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

(bind-key "C-c e" 'macrostep-expand emacs-lisp-mode-map)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)

(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'lisp-mode-hook (lambda () (lispy-mode 1)))

;;; 20elisp.el ends here
