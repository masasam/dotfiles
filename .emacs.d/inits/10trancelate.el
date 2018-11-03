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
  (if (region-active-p)
      (progn (setq mark-active nil)
	     (if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			       (buffer-substring (region-beginning) (region-end)))
		 (google-translate-translate
		  "en" "ja"
		  (buffer-substring
		   (region-beginning) (region-end)))
	       (google-translate-translate
		"ja" "en"
		(buffer-substring
		 (region-beginning) (region-end)))))
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


(push "*Google Translate*" popwin:special-display-config)
