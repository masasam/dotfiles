;;; 12nautilus.el --- 12nautilus.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun nautilus-open ()
  "Open current directry with nautilus."
  (interactive)
  (shell-command (concat "xdg-open " default-directory)))


(defun nautilus-backup ()
  "Open backup directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/backup"))


(defun nautilus-work ()
  "Open work directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/backup/work"))


(defun nautilus-cash ()
  "Open cash directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/backup/cash"))


(defun nautilus-downloads ()
  "Open downloads directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Downloads"))


(defun nautilus-documents ()
  "Open documents directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Documents"))


(defun nautilus-pictures ()
  "Open pictures directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Pictures"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 12nautilus.el ends here
