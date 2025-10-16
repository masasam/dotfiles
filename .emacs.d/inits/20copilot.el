;;; 20copilot.el --- 20copilot.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package copilot
  :bind
  ((:map copilot-completion-map ("<tab>" . copilot-accept-completion))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 20copilot.el ends here
