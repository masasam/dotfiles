;;; 30yaml.el --- 30yaml.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package yaml-ts-mode
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :hook (yaml-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 30yaml.el ends here
