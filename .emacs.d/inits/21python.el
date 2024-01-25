;;; 21python.el --- 21python.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun get-pdm-packages-path ()
  "For the current PDM project, find the path to the packages."
  (let ((packages-path (string-trim (shell-command-to-string "pdm info --packages"))))
    (concat packages-path "/lib")))

(defun my/eglot-workspace-config (server)
  "For the current PDM project, dynamically generate a python lsp config."
  `(:python\.analysis (:extraPaths ,(vector (get-pdm-packages-path)))))

(setq-default eglot-workspace-configuration #'my/eglot-workspace-config)

(setq python-indent-guess-indent-offset-verbose nil)

(add-hook 'python-mode-hook 'eglot-ensure)
;; (add-hook 'python-mode-hook (lambda ()
;;                               (require 'lsp-pyright)
;;                               (lsp-deferred)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 21python.el ends here
