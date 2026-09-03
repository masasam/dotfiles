;;; 29sh.el --- 29sh.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package sh-script
  :hook
  (bash-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 29sh.el ends here
