;;; 12nautilus.el --- 12nautilus.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun nautilus-open ()
  "Open current directry with nautilus."
  (interactive)
  (shell-command (concat "xdg-open " default-directory)))


(defun nautilus-dropbox ()
  "Open dropbox directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Dropbox"))


(defun nautilus-work ()
  "Open work directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Dropbox/work"))


(defun nautilus-cash ()
  "Open cash directry with nautilus."
  (interactive)
  (shell-command "xdg-open ~/Dropbox/cash"))


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

;;; 12nautilus.el ends here
