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
