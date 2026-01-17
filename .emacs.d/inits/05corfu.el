;;; 05corfu.el --- 05corfu.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package corfu
  :custom ((corfu-auto t)
           (corfu-auto-prefix 1))
  :bind ((:map corfu-map ("C-s" . corfu-insert-separator)))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))

(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 05corfu.el ends here
