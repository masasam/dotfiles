(defun notify-send-after-save-hook ()
  (shell-command
   (format "notify-send -i /usr/share/icons/hicolor/24x24/apps/emacs.png \"%s を保存しました\""
	   (buffer-name (current-buffer)))))
(add-hook 'after-save-hook 'notify-send-after-save-hook)
