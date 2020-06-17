(require 'solarized)
(deftheme solarized-iceberg-dark "The solarized-iceberg-dark colour theme of Solarized colour theme flavor.")
(solarized-with-color-variables 'dark 'solarized-iceberg-dark
  '((base03 . "#151720")
    (base02 . "#1a1c25")
    (base01 . "#4c4e58")
    (base00 . "#555760")
    (base0 . "#6a6c75")
    (base1 . "#757680")
    (base2 . "#b9bbc4")
    (base3 . "#c5c7d0")
    (yellow . "#e2a478")
    (orange . "#e27878")
    (red . "#e27878")
    (magenta . "#a093c7")
    (violet . "#b4be82")
    (blue . "#84a0c6")
    (cyan . "#89b8c2")
    (green . "#84a0c6")
    (yellow-d . "#3a3031")
    (yellow-l . "#cdc0be")
    (orange-d . "#3b2930")
    (orange-l . "#ceb7bd")
    (red-d . "#3b2930")
    (red-l . "#ceb7bd")
    (magenta-d . "#2d2d3d")
    (magenta-l . "#bdbcce")
    (violet-d . "#323432")
    (violet-l . "#c2c5c0")
    (blue-d . "#292f3d")
    (blue-l . "#b8bfce")
    (cyan-d . "#2a333d")
    (cyan-l . "#b9c4cd")
    (green-d . "#292f3d")
    (green-l . "#b8bfce")
    (yellow-1bg . "#31292d")
    (orange-1bg . "#31252c")
    (red-1bg . "#31252c")
    (magenta-1bg . "#272736")
    (blue-1bg . "#242936")
    (cyan-1bg . "#252c35")
    (green-1bg . "#242936")
    (violet-1bg . "#2b2c2e")
    (yellow-1fg . "#dbae91")
    (orange-1fg . "#dc9091")
    (red-1fg . "#dc9091")
    (magenta-1fg . "#aba2c9")
    (violet-1fg . "#b9c099")
    (blue-1fg . "#98abc8")
    (cyan-1fg . "#9bbcc5")
    (green-1fg . "#98abc8")
    (yellow-2bg . "#614a42")
    (orange-2bg . "#613c41")
    (red-2bg . "#613c41")
    (magenta-2bg . "#48445d")
    (violet-2bg . "#505345")
    (blue-2bg . "#3e495c")
    (cyan-2bg . "#40515b")
    (green-2bg . "#3e495c")
    (yellow-2fg . "#d8b39f")
    (orange-2fg . "#d99c9e")
    (red-2fg . "#d99c9e")
    (magenta-2fg . "#b0a9ca")
    (violet-2fg . "#bcc1a4")
    (blue-2fg . "#a1b1ca")
    (cyan-2fg . "#a4bec7")
    (green-2fg . "#a1b1ca"))
  '((custom-theme-set-faces theme-name
			    `(default
			       ((,class
				 (:foreground ,base3 :background ,base03))))
			    `(vertical-border
			      ((,class
				(:foreground ,base03))))
			    `(mode-line
			      ((,class
				(:foreground ,base2 :background ,base02))))
			    `(mode-line-inactive
			      ((,class
				(:foreground ,base0 :background ,base03))))
			    `(font-lock-comment-delimiter-face
			      ((,class
				(:foreground "#6b7089"))))
			    `(font-lock-comment-face
			      ((,class
				(:foreground "#6b7089"))))
			    `(font-lock-preprocessor-face
			      ((,class
				(:foreground ,green))))
			    `(font-lock-type-face
			      ((,class
				(:foreground ,cyan))))
			    `(font-lock-builtin-face
			      ((,class
				(:foreground ,green))))
			    `(diff-function
			      ((,class
				(:foreground ,violet-1fg))))
			    `(diff-header
			      ((,class
				(:foreground ,green))))
			    `(diff-hunk-header
			      ((,class
				(:foreground ,green))))
			    `(diff-file-header
			      ((,class
				(:background ,base03 :foreground ,green))))
			    `(diff-added
			      ((,class
				(:background ,violet-1bg :foreground ,violet-1fg))))
			    `(diff-indicator-added
			      ((t
				(:foreground ,violet))))
			    `(markdown-header-face
			      ((,class
				(:foreground ,yellow))))
			    `(markdown-header-rule-face
			      ((,class
				(:foreground ,green))))
			    `(markdown-markup-face
			      ((,class
				(:inherit default))))
			    `(markdown-url-face
			      ((,class
				(:foreground ,magenta))))
			    `(markdown-link-face
			      ((,class
				(:foreground ,green :underline t))))
			    `(markdown-inline-code-face
			      ((,class
				(:foreground ,cyan))))
			    `(markdown-pre-face
			      ((,class
				(:foreground ,cyan))))
			    `(sh-quoted-exec
			      ((,class
				(:foreground ,violet))))
			    `(haskell-type-face
			      ((,class
				(:inherit default))))
			    `(haskell-constructor-face
			      ((,class
				(:inherit default))))
			    `(haskell-operator-face
			      ((,class
				(:foreground ,green))))
			    `(haskell-definition-face
			      ((,class
				(:inherit default))))
			    `(web-mode-block-delimiter-face
			      ((,class
				(:inherit default))))
			    `(web-mode-html-attr-value-face
			      ((,class
				(:foreground ,cyan))))
			    `(web-mode-mode-type-face
			      ((,class
				(:inherit default))))
			    `(web-mode-function-call-face
			      ((,class
				(:inherit default))))
			    `(web-mode-keyword-face
			      ((,class
				(:foreground ,green))))
			    `(web-mode-constant-face
			      ((,class
				(:foreground ,cyan))))
			    `(web-mode-variable-name-face
			      ((,class
				(:foreground ,cyan))))
			    `(web-mode-html-tag-bracket-face
			      ((,class
				(:foreground ,green))))
			    `(org-verbatim
			      ((,class
				(:foreground ,cyan))))
			    `(php-php-tag
			      ((,class
				(:inherit default))))
			    `(php-constant
			      ((,class
				(:inherit default))))
			    `(php-paamayim-nekudotayim
			      ((,class
				(:foreground ,green))))
			    `(php-object-op
			      ((,class
				(:foreground ,cyan))))
			    `(php-variable-name
			      ((,class
				(:foreground ,cyan))))
			    `(php-variable-sigil
			      ((,class
				(:foreground ,cyan)))))))
(provide-theme 'solarized-iceberg-dark)
(provide 'solarized-iceberg-dark-theme)
