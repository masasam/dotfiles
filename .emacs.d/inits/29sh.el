;;; 29sh.el --- 29sh.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package bash-ts-mode
  :hook
  (bash-ts-mode . eglot-ensure)
  :init
  (add-to-list 'major-mode-remap-alist '(sh-mode . bash-ts-mode)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 29sh.el ends here
