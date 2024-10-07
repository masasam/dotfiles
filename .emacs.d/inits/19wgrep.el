;;; 19wgrep.el --- 19wgrep.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)
(setq wgrep-enable-key "e")


;; deadgrep-mode
(with-eval-after-load 'deadgrep
  (bind-keys :map deadgrep-mode-map
	     ("n" . next-line)
	     ("p" . previous-line)
	     ("j" . deadgrep-forward)
	     ("k" . deadgrep-backward)))

;;; 19wgrep.el ends here
