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


(defun chromium-calendar ()
  "Open google-calendar with chromium."
  (interactive)
  (browse-url "https://calendar.google.com/calendar/r"))


(defun chromium-meeting ()
  "Open meeting.new with chromium."
  (interactive)
  (browse-url "https://meeting.new"))


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


(defun chromium-keep ()
  "Open keep with chromium."
  (interactive)
  (browse-url "https://keep.google.com/u/0/"))


(defun chromium-minikube ()
  "Open minikube service server with chromium."
  (interactive)
  (browse-url "http://localhost:8080"))


(defun chromium-rails ()
  "Open rails development server with chromium."
  (interactive)
  (browse-url "http://localhost:3000"))


(defun chromium-django ()
  "Open django development server with chromium."
  (interactive)
  (browse-url "http://localhost:8000"))


(defun chromium-django-admin ()
  "Open django development admin server with chromium."
  (interactive)
  (browse-url "http://localhost:8000/admin/"))


(defun chromium-local ()
  "Open development page with chromium."
  (interactive)
  (browse-url "file:///home/masa/src/github.com/masasam/vue/index.html"))

;;; 13chromium.el ends here
