(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

(bind-key "C-c e" 'macrostep-expand emacs-lisp-mode-map)
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
