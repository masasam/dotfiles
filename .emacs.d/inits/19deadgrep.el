;;; 19deadgrep.el --- 19deadgrep.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; deadgrep-mode
(with-eval-after-load 'deadgrep
  (bind-keys :map deadgrep-mode-map
	     ("n" . next-line)
	     ("p" . previous-line)
	     ("j" . deadgrep-forward)
	     ("k" . deadgrep-backward)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 19deadgrep.el ends here
