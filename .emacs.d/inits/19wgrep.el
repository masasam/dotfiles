;;; 19wgrep.el --- 19wgrep.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
(setq wgrep-enable-key "e")

;;; 19wgrep ends here
