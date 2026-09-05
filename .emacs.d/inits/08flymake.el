;;; 08flymake.el --- 08flymake.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; flymake
(with-eval-after-load 'flymake
  ;; (add-hook 'emacs-lisp-mode-hook #'package-lint-flymake-setup)
  (setq flymake-show-diagnostics-at-end-of-line 'fancy))
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)


(require 'puni)
(puni-global-mode)
(add-hook 'term-mode-hook #'puni-disable-puni-mode)


(use-package eldoc-box
  :hook ((eglot-managed-mode . eldoc-box-hover-mode)
		 (emacs-lisp-mode-hook . eldoc-box-hover-mode)
		 (lisp-interaction-mode-hook . eldoc-box-hover-mode)
		 (ielm-mode-hook . eldoc-box-hover-mode)))


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 08flymake.el ends here
