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
(bind-key "C-M-i" 'company-complete)
(bind-key "C-h" nil company-active-map)
(bind-key "C-n" 'company-select-next company-active-map)
(bind-key "C-p" 'company-select-previous company-active-map)
(bind-key "C-n" 'company-select-next company-search-map)
(bind-key "C-p" 'company-select-previous company-search-map)
(bind-key "<tab>" 'company-complete-common-or-cycle company-active-map)
(bind-key "M-d" 'company-show-doc-buffer company-active-map)
