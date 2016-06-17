;;; 全角文字と半角英字の間に半角スペースを入れる
(setq pangu-spacing-chinese-before-english-regexp
  (rx (group-n 1 (category japanese))
      (group-n 2 (in "a-zA-Z0-9"))))
(setq pangu-spacing-chinese-after-english-regexp
  (rx (group-n 1 (in "a-zA-Z0-9"))
      (group-n 2 (category japanese))))
;;; 見た目ではなくて実際にスペースを入れる
(setq pangu-spacing-real-insert-separtor t)
;; markdown-modeで利用する
(add-hook 'markdown-mode-hook 'pangu-spacing-mode)
