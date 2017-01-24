(require 'company)
(add-hook 'yaml-mode-hook
          (lambda ()
            (company-mode 1)))
(add-hook 'yaml-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-ansible)))
(add-hook 'irony-mode-hook
          (lambda ()
            (company-mode 1)))
(add-hook 'irony-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-irony)))

;; general
(setq comany-idle-delay 0.1)
(setq comany-minimum-prefix-length 1)
(setq comany-selection-wrap-around t)
;; (setq company-idle-delay nil) ; Do not autocomplete
(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "C-h") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "M-d") 'company-show-doc-buffer)
