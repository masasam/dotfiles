(require 'google-translate)
(require 'google-translate-default-ui)

(defun google-translate-enja-or-jaen (&optional string)
  "Translate words in region or current position. Can also specify query with C-u"
  (interactive)
  (setq string
        (cond ((stringp string) string)
              (current-prefix-arg
               (read-string "Google Translate: "))
              ((use-region-p)
               (buffer-substring (region-beginning) (region-end)))
              (t
               (thing-at-point 'word))))
  (let* ((asciip (string-match
                  (format "\\`[%s]+\\'" "[:ascii:]")
                  string)))
    (run-at-time 0.1 nil 'deactivate-mark)
    (google-translate-translate
     (if asciip "en" "ja")
     (if asciip "ja" "en")
     string)))

(push "*Google Translate*" popwin:special-display-config)
(bind-key "C-c t" 'google-translate-enja-or-jaen)

(defun google-translate--get-b-d1 ()
  ;; TKK='427110.1469889687'
  (list 427110 1469889687))
