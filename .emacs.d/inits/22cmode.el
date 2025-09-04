;;; 22cmode.el --- 22cmode.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package c-ts-mode
  :mode ("\\.c$" . c-ts-mode)
  :config
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  :hook
  (c-ts-mode . eglot-ensure))

(use-package c++-ts-mode
  :mode ("\\.cpp$" . c++-ts-mode)
  :hook
  (c++-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 22cmode.el ends here
