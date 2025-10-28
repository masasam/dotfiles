;;; 12nautilus.el --- 12nautilus.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun nautilus-open ()
  "Open current directry with nautilus."
  (interactive)
  (shell-command (concat "nautilus " default-directory)))


(defun nautilus-backup ()
  "Open backup directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/backup"))


(defun nautilus-work ()
  "Open work directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/backup/work"))


(defun nautilus-cash ()
  "Open cash directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/backup/cash"))


(defun nautilus-downloads ()
  "Open downloads directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/Downloads"))


(defun nautilus-documents ()
  "Open documents directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/Documents"))


(defun nautilus-pictures ()
  "Open pictures directry with nautilus."
  (interactive)
  (shell-command "nautilus ~/Pictures"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 12nautilus.el ends here
