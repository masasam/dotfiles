;;; 13chromium.el --- 13chromium.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'url-util)
(require 'browse-url)
(require 'json)
(require 'cl-lib)

(defvar my/chrome-focus-timer nil
  "Pending attempt to focus Chrome after opening a URL.")

(defun my/chrome-focus-window (&optional attempts)
  "Focus the most recently used Chrome window, retrying ATTEMPTS times."
  (setq my/chrome-focus-timer nil)
  (when (and (getenv "HYPRLAND_INSTANCE_SIGNATURE")
             (executable-find "hyprctl"))
    (let ((default-directory (expand-file-name "~/"))
          (case-fold-search t)
          address)
      (condition-case err
          (with-temp-buffer
            (when (eq 0 (call-process "hyprctl" nil t nil "clients" "-j"))
              (goto-char (point-min))
              (let* ((clients (json-parse-buffer :object-type 'alist :array-type 'list))
                     (windows
                      (cl-remove-if-not
                       (lambda (client)
                         (string-match-p
                          "\\`\\(?:google-chrome\\(?:-beta\\|-unstable\\)?\\|chromium\\)\\'"
                          (or (alist-get 'class client) "")))
                       clients))
                     (window
                      (car (sort windows
                                 (lambda (a b)
                                   (< (or (alist-get 'focusHistoryID a) 99999)
                                      (or (alist-get 'focusHistoryID b) 99999)))))))
                (setq address (alist-get 'address window)))))
        (error (message "Chrome focus: %s" (error-message-string err))))
      (if (and (stringp address)
               (string-match-p "\\`0x[[:xdigit:]]+\\'" address))
          (make-process
           :name "chrome-focus" :buffer nil :noquery t
           :command
           (list "hyprctl" "dispatch"
                 (format "hl.dsp.focus({ window = \"address:%s\" })" address)))
        (when (> (or attempts 0) 0)
          (setq my/chrome-focus-timer
                (run-at-time 0.2 nil #'my/chrome-focus-window (1- attempts))))))))

(defun my/chrome-browse-url (url)
  "Open URL in Chrome and focus its Hyprland window."
  (browse-url-chrome url)
  (when (timerp my/chrome-focus-timer)
    (cancel-timer my/chrome-focus-timer))
  (setq my/chrome-focus-timer
        (run-at-time 0.25 nil #'my/chrome-focus-window 24)))


(defun chrome-translate ()
  "Open google translate with chrome."
  (interactive)
  (if (use-region-p)
      (let ((string (buffer-substring-no-properties (region-beginning) (region-end))))
	(deactivate-mark)
	(if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			  string)
	    (my/chrome-browse-url (concat "https://translate.google.com/?source=gtx#en/ja/"
				(url-hexify-string string)))
	  (my/chrome-browse-url (concat "https://translate.google.com/?source=gtx#ja/en/"
			      (url-hexify-string string)))))
    (let ((string (read-string "Google Translate: ")))
      (if (string-match
	   (format "\\`[%s]+\\'" "[:ascii:]")
	   string)
	  (my/chrome-browse-url
	   (concat "https://translate.google.com/?source=gtx#en/ja/" (url-hexify-string string)))
	(my/chrome-browse-url
	 (concat "https://translate.google.com/?source=gtx#ja/en/" (url-hexify-string string)))))))

(defun chrome-remix (input)
  "Open remix development server with chrome."
  (interactive (list (read-from-minibuffer "http://localhost:5173/" nil nil nil nil)))
  (my/chrome-browse-url (concat "http://localhost:5173/" input)))

(defun chrome-rails (input)
  "Open rails development server with chrome."
(interactive (list (read-from-minibuffer "http://127.0.0.1:3000/" nil nil nil nil)))
  (my/chrome-browse-url (concat "http://127.0.0.1:3000/" input)))

(defun chrome-django (input)
  "Open django development server with chrome."
  (interactive (list (read-from-minibuffer "http://127.0.0.1:8000/" nil nil nil nil)))
  (my/chrome-browse-url (concat "http://127.0.0.1:8000/" input)))

(defun chrome-calendar ()
  "Open google-calendar with chrome."
  (interactive)
  (my/chrome-browse-url "https://calendar.google.com/calendar/r"))

(defun chrome-meeting ()
  "Open meeting.new with chrome."
  (interactive)
  (my/chrome-browse-url "https://meeting.new"))

(defun chrome-gmail ()
  "Open gmail with chrome."
  (interactive)
  (my/chrome-browse-url "https://mail.google.com/mail/u/0/#inbox"))

(defun chrome-drive ()
  "Open google-drive with chrome."
  (interactive)
  (my/chrome-browse-url "https://drive.google.com/drive/u/0/my-drive"))

(defun chrome-github ()
  "Open github with chrome."
  (interactive)
  (my/chrome-browse-url "https://github.com/masasam"))

(defun chrome-github-new ()
  "Open github with chrome."
  (interactive)
  (my/chrome-browse-url "https://repo.new/"))

(defun chrome-reddit ()
  "Open reddit with chrome."
  (interactive)
  (my/chrome-browse-url "https://www.reddit.com"))

(defun chrome-hackernews ()
  "Open hackernews with chrome."
  (interactive)
  (my/chrome-browse-url "https://news.ycombinator.com"))

(defun chrome-maps ()
  "Open google-maps with chrome."
  (interactive)
  (my/chrome-browse-url "https://www.google.com/maps/"))

(defun chrome-x ()
  "Open twitter with chrome."
  (interactive)
  (my/chrome-browse-url "https://x.com/"))

(defun chrome-keep ()
  "Open keep with chrome."
  (interactive)
  (my/chrome-browse-url "https://keep.google.com/u/0/"))

(defun chrome-keep-new ()
  "Open new keep with chrome."
  (interactive)
  (my/chrome-browse-url "https://keep.new"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 13chromium.el ends here
