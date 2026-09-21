;;; 35yaml.el --- 35yaml.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package yaml-ts-mode
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :hook (yaml-ts-mode . eglot-ensure))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 35yaml.el ends here
