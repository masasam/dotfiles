;;; 13chromium.el --- 13chromium.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'url-util)

(defun chromium-translate ()
  "Open google translate with chromium."
  (interactive)
  (if (use-region-p)
      (let ((string (buffer-substring-no-properties (region-beginning) (region-end))))
	(deactivate-mark)
	(if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			  string)
	    (browse-url (concat "https://translate.google.com/?source=gtx#en/ja/"
				(url-hexify-string string)))
	  (browse-url (concat "https://translate.google.com/?source=gtx#ja/en/"
			      (url-hexify-string string)))))
    (let ((string (read-string "Google Translate: ")))
      (if (string-match
	   (format "\\`[%s]+\\'" "[:ascii:]")
	   string)
	  (browse-url
	   (concat "https://translate.google.com/?source=gtx#en/ja/" (url-hexify-string string)))
	(browse-url
	 (concat "https://translate.google.com/?source=gtx#ja/en/" (url-hexify-string string)))))))


(defun chrome-rails (input)
  "Open rails development server with chromium."
(interactive (list (read-from-minibuffer "http://127.0.0.1:8000/" nil nil nil nil)))
  (browse-url (concat "http://127.0.0.1:3000/" input)))


(defun chrome-django (input)
  "Open django development server with chromium."
  (interactive (list (read-from-minibuffer "http://127.0.0.1:8000/" nil nil nil nil)))
  (browse-url (concat "http://127.0.0.1:8000/" input)))


(defun chrome-django-admin ()
  "Open django development admin server with chromium."
  (interactive)
  (browse-url "http://127.0.0.1:8000/admin/"))


(defun chrome-js (input)
  "Open js development page with chromium."
  (interactive (list (read-from-minibuffer "http://127.0.0.1:8000/" nil nil nil nil)))
  (browse-url (concat "http://127.0.0.1:8080/" input)))


(defun chrome-calendar ()
  "Open google-calendar with chromium."
  (interactive)
  (browse-url "https://calendar.google.com/calendar/r"))


(defun chrome-meeting ()
  "Open meeting.new with chromium."
  (interactive)
  (browse-url "https://meeting.new"))


(defun chrome-gmail ()
  "Open gmail with chromium."
  (interactive)
  (browse-url "https://mail.google.com/mail/u/0/#inbox"))


(defun chrome-drive ()
  "Open google-drive with chromium."
  (interactive)
  (browse-url "https://drive.google.com/drive/u/0/my-drive"))


(defun chrome-github ()
  "Open github with chromium."
  (interactive)
  (browse-url "https://repo.new/"))


(defun chrome-reddit ()
  "Open reddit with chromium."
  (interactive)
  (browse-url "https://www.reddit.com"))


(defun chrome-hackernews ()
  "Open hackernews with chromium."
  (interactive)
  (browse-url "https://news.ycombinator.com"))


(defun chrome-maps ()
  "Open google-maps with chromium."
  (interactive)
  (browse-url "https://www.google.co.jp/maps"))


(defun chrome-pocket ()
  "Open pocket with chromium."
  (interactive)
  (browse-url "https://getpocket.com/a/queue/"))


(defun chrome-twitter ()
  "Open twitter with chromium."
  (interactive)
  (browse-url "https://twitter.com"))


(defun chrome-keep ()
  "Open keep with chromium."
  (interactive)
  (browse-url "https://keep.google.com/u/0/"))


(defun chrome-keep-new ()
  "Open new keep with chromium."
  (interactive)
  (browse-url "https://keep.new"))

;;; 13chromium.el ends here
