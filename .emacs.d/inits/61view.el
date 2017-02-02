(defun View-goto-line-last (&optional line)
  "goto last line"
  (interactive "P")
  (goto-line (line-number-at-pos (point-max))))

;; view-mode
(setq view-read-only t)
(require 'view)
;; less like
(require 'bind-key)
(bind-key "N" 'View-search-last-regexp-backward view-mode-map)
(bind-key "?" 'View-search-regexp-backward view-mode-map)
(bind-key "G" 'View-goto-line-last view-mode-map)
(bind-key "b" 'View-scroll-page-backward view-mode-map)
(bind-key "f" 'View-scroll-page-forward view-mode-map)
;; vi/w3m like
(bind-key "h" 'backward-char view-mode-map)
(bind-key "j" 'next-line view-mode-map)
(bind-key "k" 'previous-line view-mode-map)
(bind-key "l" 'forward-char view-mode-map)
(bind-key "J" 'View-scroll-line-forward view-mode-map)
(bind-key "K" 'View-scroll-line-backward view-mode-map)
