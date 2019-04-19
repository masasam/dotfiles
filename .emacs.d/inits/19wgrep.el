;;; 19wgrep.el --- 19wgrep.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
(setq wgrep-enable-key "e")


;; for deadgrep-mode
(bind-key "n" 'next-line deadgrep-mode-map)
(bind-key "p" 'previous-line deadgrep-mode-map)

;;; 19wgrep ends here
