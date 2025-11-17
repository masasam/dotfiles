;;; 95elisp.el --- 95elisp.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

(bind-key "C-c e" 'macrostep-expand emacs-lisp-mode-map)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 95elisp.el ends here
