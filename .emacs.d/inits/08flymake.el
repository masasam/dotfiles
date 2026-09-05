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

(defun my/eldoc-box-help-toggle ()
  "Show or hide Eldoc documentation without focusing its child frame."
  (interactive)
  (let ((frame (and (boundp 'eldoc-box--frame)
		    (symbol-value 'eldoc-box--frame))))
    (if (and (frame-live-p frame) (frame-visible-p frame))
	(eldoc-box-quit-frame)
      (eldoc-box-help-at-point))))


(use-package eldoc-box
  :bind ("C-c d" . my/eldoc-box-help-toggle)
  :custom ((eldoc-box-only-multi-line t)
	   (eldoc-box-clear-with-C-g t))
  :hook ((eglot-managed-mode . eldoc-box-hover-mode)
		 (emacs-lisp-mode . eldoc-box-hover-mode)
		 (lisp-interaction-mode . eldoc-box-hover-mode)
		 (ielm-mode . eldoc-box-hover-mode)))


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 08flymake.el ends here
