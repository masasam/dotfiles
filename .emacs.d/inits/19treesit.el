;;; 19treesit.el --- 19treesit.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package treesit
  :config
  (setq treesit-font-lock-level 4))

(setq treesit-language-source-alist
      '((json "https://github.com/tree-sitter/tree-sitter-json")
		(rust "https://github.com/tree-sitter/tree-sitter-rust")))

(dolist (element treesit-language-source-alist)
  (let* ((lang (car element)))
    (if (treesit-language-available-p lang)
        (message "treesit: %s is already installed" lang)
      (message "treesit: %s is not installed" lang)
      (treesit-install-language-grammar lang))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 19treesit.el ends here
