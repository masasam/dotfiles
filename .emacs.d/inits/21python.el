;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'python-mode-hook 'eglot-ensure)
((python-mode
  . ((eglot-workspace-configuration
      . ((:pyls . (:plugins (:jedi_completion (:include_params t)))))))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
