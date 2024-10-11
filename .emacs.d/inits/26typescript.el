;;; 26typescript.el --- 26typescript.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package typescript-ts-mode
  :mode (("\\\\.tsx\\\\'" . tsx-ts-mode)
         ("\\\\.ts\\\\'" . tsx-ts-mode))
  :config
  (setq typescript-ts-mode-indent-offset 2))

(use-package treesit
  :config
  (setq treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :init
  (require 'treesit-auto)
  (global-treesit-auto-mode)
  :config
  (setq treesit-auto-install t))

(use-package tree-sitter
  :ensure t
  :hook ((typescript-ts-mode . tree-sitter-hl-mode)
         (tsx-ts-mode . tree-sitter-hl-mode))
  :config
  (global-tree-sitter-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-ts-mode . tsx)))


(add-hook 'typescript-ts-mode-hook #'lsp)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 26typescript.el ends here
