;;; 18file.el --- 18file
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; (global-aggressive-indent-mode 1)
;; (add-to-list 'aggressive-indent-excluded-modes 'slim-mode)


;; Openwith
(openwith-mode t)
(setq openwith-associations
      (list (list (openwith-make-extension-regexp '("pdf"))
                  "evince" '(file))
			(list (openwith-make-extension-regexp '("svg"))
                  "inkscape" '(file))
            (list (openwith-make-extension-regexp '("flac" "mp3" "wav"))
                  "mpv" '(file))
            (list (openwith-make-extension-regexp '("avi" "flv" "mov" "mp4"
                                                    "mpeg" "mpg" "ogg" "wmv"))
                  "mpv" '(file))
            (list (openwith-make-extension-regexp '("doc" "docx" "odt"))
                  "libreoffice" '("--writer" file))
            (list (openwith-make-extension-regexp '("ods" "xls" "xlsx"))
                  "libreoffice" '("--calc" file))
            (list (openwith-make-extension-regexp '("odp" "pps" "ppt" "pptx"))
                  "libreoffice" '("--impress" file))))

;;; 18file.el ends here
