;;; 34lua.el --- 34lua.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package lua-ts-mode
  :mode
  ("\\.lua\\'" . lua-ts-mode)
  :hook
  (lua-ts-mode . eglot-ensure)
)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34lua.el ends here
