;;; 98copilot.el --- 98copilot.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package copilot
  :hook   ((typescript-ts-mode .  copilot-mode)
		   (tsx-ts-mode .  copilot-mode))
  :bind
  ((:map copilot-completion-map ("<tab>" . copilot-accept-completion))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 98copilot.el ends here
