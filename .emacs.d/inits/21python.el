;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'python-mode-hook 'eglot-ensure)

(add-to-list 'eglot-server-programs
             `(python-mode . ("pyls" "-v" "--tcp" "--host"
                              "localhost" "--port" :autoport))))
;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
