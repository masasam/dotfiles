;;; 20elisp.el --- 20elisp.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))

(bind-key "C-c e" 'macrostep-expand emacs-lisp-mode-map)

(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'lisp-mode-hook (lambda () (lispy-mode 1)))
;; (add-hook 'emacs-lisp-mode-hook (contribute-swiper)))

(defun contribute-swiper()
  "Swiper project setting."
  (setq indent-tabs-mode nil)
  (require 'cl-indent)
  (setq lisp-indent-function #'common-lisp-indent-function)
  (put 'if 'common-lisp-indent-function 2)
  (put 'defface 'common-lisp-indent-function 1)
  (put 'defalias 'common-lisp-indent-function 1)
  (put 'define-minor-mode 'common-lisp-indent-function 1)
  (put 'define-derived-mode 'common-lisp-indent-function 3)
  (put 'cl-flet 'common-lisp-indent-function
       (get 'flet 'common-lisp-indent-function))
  (put 'cl-labels 'common-lisp-indent-function
       (get 'labels 'common-lisp-indent-function)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 20elisp.el ends here
