;;; 26javascript.el --- 26javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))

(add-hook 'js2-mode-hook 'eglot-ensure)
(add-hook 'rjsx-mode-hook 'eglot-ensure)
(add-hook 'rjsx-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq js-indent-level 2)
            (setq js2-strict-missing-semi-warning nil)))

;; vue
(eval-after-load 'vue-mode
  '(add-hook 'vue-mode-hook #'add-node-modules-path))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26javascript.el ends here
