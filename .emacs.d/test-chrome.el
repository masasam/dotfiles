;;; test-chrome.el --- Chrome command tests -*- lexical-binding: t; -*-

(require 'ert)
(load (expand-file-name "inits/13chromium.el"
                        (file-name-directory (or load-file-name buffer-file-name)))
      nil t)

(ert-deftest my/chrome-command-uses-shared-opener ()
  (let (opened)
    (cl-letf (((symbol-function 'my/chrome-browse-url)
               (lambda (url) (setq opened url))))
      (chrome-calendar))
    (should (equal opened "https://calendar.google.com/calendar/r"))))

(ert-deftest my/chrome-opener-schedules-focus ()
  (let (opened scheduled my/chrome-focus-timer)
    (cl-letf (((symbol-function 'browse-url-chrome)
               (lambda (url) (setq opened url)))
              ((symbol-function 'run-at-time)
               (lambda (&rest args) (setq scheduled args))))
      (my/chrome-browse-url "https://example.com/"))
    (should (equal opened "https://example.com/"))
    (should (equal scheduled '(0.25 nil my/chrome-focus-window 24)))))

(ert-deftest my/chrome-focus-selects-recent-browser ()
  (let (command my/chrome-focus-timer)
    (cl-letf (((symbol-function 'getenv) (lambda (&rest _) "test"))
              ((symbol-function 'executable-find) (lambda (_) "/usr/bin/hyprctl"))
              ((symbol-function 'call-process)
               (lambda (&rest _)
                 (insert "[{\"class\":\"emacs\",\"address\":\"0x01\",\"focusHistoryID\":0},"
                         "{\"class\":\"google-chrome\",\"address\":\"0x02\",\"focusHistoryID\":4},"
                         "{\"class\":\"google-chrome\",\"address\":\"0x03\",\"focusHistoryID\":1}]")
                 0))
              ((symbol-function 'make-process)
               (lambda (&rest args) (setq command (plist-get args :command)))))
      (my/chrome-focus-window 0))
    (should (equal command '("hyprctl" "dispatch"
                            "hl.dsp.focus({ window = \"address:0x03\" })")))))

(ert-deftest my/chrome-focus-retries-while-browser-starts ()
  (let (scheduled my/chrome-focus-timer)
    (cl-letf (((symbol-function 'getenv) (lambda (&rest _) "test"))
              ((symbol-function 'executable-find) (lambda (_) "/usr/bin/hyprctl"))
              ((symbol-function 'call-process)
               (lambda (&rest _) (insert "[]") 0))
              ((symbol-function 'run-at-time)
               (lambda (&rest args) (setq scheduled args))))
      (my/chrome-focus-window 2))
    (should (equal scheduled '(0.2 nil my/chrome-focus-window 1)))))

;;; test-chrome.el ends here
