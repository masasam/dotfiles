;;; 29sh.el --- 29sh.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode))

(use-package bash-ts-mode
  :hook
  (bash-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 29sh.el ends here
