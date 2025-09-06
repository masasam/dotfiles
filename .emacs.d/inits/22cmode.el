;;; 22cmode.el --- 22cmode.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package c-ts-mode
  :hook (c-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-hook 'c-mode-common-hook 'google-set-c-style))

(use-package c++-ts-mode
  :hook (c++-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 22cmode.el ends here
