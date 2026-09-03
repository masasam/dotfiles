;;; 12pcmanfm.el --- 12pcmanfm.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun pcmanfm-open ()
  "Open current directry with pcmanfm."
  (interactive)
  (start-process "pcmanfm" nil "pcmanfm-qt"
		 (expand-file-name default-directory)))


(defun pcmanfm-backup ()
  "Open backup directry with pcmanfm."
  (interactive)
  (start-process "pcmanfm" nil "pcmanfm-qt" (expand-file-name "~/backup")))


(defun pcmanfm-downloads ()
  "Open downloads directry with pcmanfm."
  (interactive)
  (start-process "pcmanfm" nil "pcmanfm-qt" (expand-file-name "~/Downloads")))


(defun pcmanfm-documents ()
  "Open documents directry with pcmanfm."
  (interactive)
  (start-process "pcmanfm" nil "pcmanfm-qt" (expand-file-name "~/Documents")))


(defun pcmanfm-pictures ()
  "Open pictures directry with pcmanfm."
  (interactive)
  (start-process "pcmanfm" nil "pcmanfm-qt" (expand-file-name "~/Pictures")))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 12pcmanfm.el ends here
