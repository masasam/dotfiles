;;; 20reformatter.el --- 20reformatter.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package reformatter
  :config
  (reformatter-define go-format
    :program "goimports")
  (reformatter-define web-format
    :program "prettier"
    :args `("--write" "--stdin-filepath" ,buffer-file-name))
  (reformatter-define python-format
    :program "ruff"
    :args `("format" "--stdin-filename" ,buffer-file-name))
  :hook
  (go-mode . go-format-on-save-mode)
  (tsx-ts-mode . web-format-on-save-mode)
  (json-ts-mode . web-format-on-save-mode)
  (python-ts-mode . python-format-on-save-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 20reformatter.el ends here
