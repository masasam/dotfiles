;;; 08flymake.el --- 08flymake.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; flymake
(require 'flymake-diagnostic-at-point)
(with-eval-after-load 'flymake
  (add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)
  ;; (add-hook 'emacs-lisp-mode-hook #'package-lint-flymake-setup)
  (set-face-attribute 'popup-tip-face nil
		      :background "dark slate gray" :foreground "white" :underline nil))
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)

;; flymake-posframe
(defvar flymake-posframe-hide-posframe-hooks
  '(pre-command-hook post-command-hook focus-out-hook)
  "The hooks which should trigger automatic removal of the posframe.")

(defun flymake-posframe-hide-posframe ()
  "Hide messages currently being shown if any."
  (posframe-hide " *flymake-posframe-buffer*")
  (dolist (hook flymake-posframe-hide-posframe-hooks)
    (remove-hook hook #'flymake-posframe-hide-posframe t)))

(defun my/flymake-diagnostic-at-point-display-popup (text)
  "Display the flymake diagnostic TEXT inside a posframe."
  (posframe-show " *flymake-posframe-buffer*"
		 :string (concat flymake-diagnostic-at-point-error-prefix
				 (flymake--diag-text
				  (get-char-property (point) 'flymake-diagnostic)))
		 :position (point)
		 :foreground-color "cyan"
		 :internal-border-width 2
		 :internal-border-color "red"
		 :poshandler 'posframe-poshandler-window-bottom-left-corner)
  (dolist (hook flymake-posframe-hide-posframe-hooks)
    (add-hook hook #'flymake-posframe-hide-posframe nil t)))

(advice-add 'flymake-diagnostic-at-point-display-popup :override 'my/flymake-diagnostic-at-point-display-popup)


;; flyspell-correct
(define-key flyspell-mode-map (kbd "C-;") #'flyspell-correct-wrapper)
(setenv "DICTIONARY" "en_US")


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
