;;; 05corfu.el --- 05corfu.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package corfu
  :ensure t
  :custom ((corfu-auto t)
           (corfu-auto-prefix 1)
           (corfu-auto-delay 0.4)
		   (corfu-popupinfo-delay 0))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 05corfu.el ends here
