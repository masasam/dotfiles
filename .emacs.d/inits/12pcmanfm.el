;;; 12pcmanfm.el --- 12pcmanfm.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun pcmanfm-open ()
  "Open current directry with pcmanfm."
  (interactive)
  (call-process-shell-command (concat "pcmanfm " default-directory)))


(defun pcmanfm-backup ()
  "Open backup directry with pcmanfm."
  (interactive)
  (call-process-shell-command "pcmanfm ~/backup"))

(defun pcmanfm-downloads ()
  "Open downloads directry with pcmanfm."
  (interactive)
  (call-process-shell-command "pcmanfm ~/Downloads"))


(defun pcmanfm-documents ()
  "Open documents directry with pcmanfm."
  (interactive)
  (call-process-shell-command "pcmanfm ~/Documents"))


(defun pcmanfm-pictures ()
  "Open pictures directry with pcmanfm."
  (interactive)
  (call-process-shell-command "pcmanfm ~/Pictures"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 12pcmanfm.el ends here
