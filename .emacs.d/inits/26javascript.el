;;; 26javascript.el --- 26javascript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\.jsx$" . js2-jsx-mode))
(require 'flycheck)
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26javascript.el ends here
