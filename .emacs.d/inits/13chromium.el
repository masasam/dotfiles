(bind-key "C-c t" 'chromium-translate)

(defun chromium-translate ()
  "Open google translate with chromium."
  (interactive)
  (if (region-active-p)
      (progn (setq mark-active nil)
	     (if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			       (buffer-substring (region-beginning) (region-end)))
		 (browse-url (concat "https://translate.google.com/?source=gtx#en/ja/"
				     (buffer-substring
				      (region-beginning) (region-end))))
	       (browse-url (concat "https://translate.google.com/?source=gtx#ja/en/"
				   (buffer-substring
				    (region-beginning) (region-end))))))
    (let ((string (read-string "Google Translate: ")))
      (if (string-match
	   (format "\\`[%s]+\\'" "[:ascii:]")
	   string)
	  (browse-url
	   (concat "https://translate.google.com/?source=gtx#en/ja/" string))
	(browse-url
	 (concat "https://translate.google.com/?source=gtx#ja/en/" string))))))


(defun chromium-calendar ()
  "Open google-calendar with chromium."
  (interactive)
  (browse-url "https://calendar.google.com/calendar/r"))


(defun chromium-gmail ()
  "Open gmail with chromium."
  (interactive)
  (browse-url "https://mail.google.com/mail/u/0/#inbox"))


(defun chromium-drive ()
  "Open google-drive with chromium."
  (interactive)
  (browse-url "https://drive.google.com/drive/u/0/my-drive"))


(defun chromium-github ()
  "Open github with chromium."
  (interactive)
  (browse-url "https://github.com/masasam"))


(defun chromium-reddit ()
  "Open reddit with chromium."
  (interactive)
  (browse-url "https://www.reddit.com"))


(defun chromium-hackernews ()
  "Open hackernews with chromium."
  (interactive)
  (browse-url "https://news.ycombinator.com"))


(defun chromium-maps ()
  "Open google-maps with chromium."
  (interactive)
  (browse-url "https://www.google.co.jp/maps"))


(defun chromium-pocket ()
  "Open pocket with chromium."
  (interactive)
  (browse-url "https://getpocket.com/a/queue/"))


(defun chromium-twitter ()
  "Open twitter with chromium."
  (interactive)
  (browse-url "https://twitter.com"))
