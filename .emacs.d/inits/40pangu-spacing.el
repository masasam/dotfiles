;; Insert a space between full-width and half-width letters
(setq pangu-spacing-chinese-before-english-regexp
      (rx (group-n 1 (category japanese))
	  (group-n 2 (in "a-zA-Z0-9"))))
(setq pangu-spacing-chinese-after-english-regexp
      (rx (group-n 1 (in "a-zA-Z0-9"))
	  (group-n 2 (category japanese))))
;; Place the actual space rather than the appearance
(setq pangu-spacing-real-insert-separtor t)
;; use markdown-mode
(add-hook 'markdown-mode-hook 'pangu-spacing-mode)
