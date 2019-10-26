;;; 30dart.el --- 30dart.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(add-hook 'dart-mode-hook 'eglot-ensure)

(setq flutter-reload-flg nil)

(defun flutter-reload()
  "Send a signal to daemon."
  (start-process "flutter-reloader" nil "pkill" "-SIGUSR1" "-f" "flutter_tool"))

(defun flutter-reload-mode()
  "Flutter reload mode."
  (interactive)
  (if flutter-reload-flg
      (progn
	(remove-hook 'after-save-hook 'flutter-reload t)
	(setq flutter-reload-flg nil)
	(message "Flutter-reload-mode disabled"))
    (add-hook 'after-save-hook 'flutter-reload t t)
    (setq flutter-reload-flg t)
    (message "Flutter-reload-mode enabled")))

(add-hook 'dart-mode-hook 'flutter-reload-mode)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 30dart.el ends here
