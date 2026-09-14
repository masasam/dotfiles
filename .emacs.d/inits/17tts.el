;;; 17tts.el --- Local text-to-speech commands -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defconst my/tts-program
  (expand-file-name "~/.config/tts/ttsctl.py")
  "Path to the local text-to-speech controller.")

(defun my/tts-speak-region-or-buffer (beg end)
  "Read the active region between BEG and END, or the current buffer."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (let ((process
         (make-process
          :name "tts-speak"
          :command (list my/tts-program "speak")
          :connection-type 'pipe
          :noquery t)))
    (process-send-string process
                         (buffer-substring-no-properties beg end))
    (process-send-eof process)))

(defun my/tts-stop ()
  "Stop the current text-to-speech playback."
  (interactive)
  (start-process "tts-stop" nil my/tts-program "stop"))

(global-set-key (kbd "C-c s") #'my/tts-speak-region-or-buffer)
(global-set-key (kbd "C-c S") #'my/tts-stop)

(provide '17tts)
;;; 17tts.el ends here
