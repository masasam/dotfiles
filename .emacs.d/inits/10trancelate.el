;;; 10trancelate.el --- 10trancelate.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'google-translate)
(require 'google-translate-default-ui)

(bind-key "C-c t" 'google-translate-auto)

(defvar toggle-translate-flg nil
  "Toggle flg.")

(defun toggle-translate ()
  "Toggle translate function."
  (interactive)
  (if toggle-translate-flg
      (progn
	(bind-key "C-c t" 'google-translate-auto)
	(setq toggle-translate-flg nil))
    (progn
      (bind-key "C-c t" 'chromium-translate)
      (setq toggle-translate-flg t))))


(defun google-translate-auto ()
  "Automatically recognize and translate Japanese and English."
  (interactive)
  (if (use-region-p)
      (let ((string (buffer-substring-no-properties (region-beginning) (region-end))))
	(deactivate-mark)
	(if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			  string)
	    (google-translate-translate
	     "en" "ja"
	     string)
	  (google-translate-translate
	   "ja" "en"
	   string)))
    (let ((string (read-string "Google Translate: ")))
      (if (string-match
	   (format "\\`[%s]+\\'" "[:ascii:]")
	   string)
	  (google-translate-translate
	   "en" "ja"
	   string)
	(google-translate-translate
	 "ja" "en"
	 string)))))


(defun google-translate--get-b-d1 ()
  (list 427110 1469889687))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 10trancelate.el ends here
