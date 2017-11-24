(add-to-list 'load-path "~/Dropbox/emacs/setting/")
(require 'setting)
;; theme
(load-theme 'material t)
;; Change part of theme to your liking.
;; Investigate by changing 'M-x list-faces-display'
(custom-set-faces
 '(fixed-pitch ((t (:family "Ricty"))))
 '(cursor ((t (:background "#82c600"))))
 '(helm-ff-prefix ((t (:foreground "#82c600"))))
 '(helm-header-line-left-margin ((t (:foreground "#82c600"))))
 '(elscreen-tab-background-face ((t (:background "#37474f"))))
 '(elscreen-tab-current-screen-face ((t (:background "LightSkyBlue4" :foreground "white"))))
 '(elscreen-tab-other-screen-face ((t (:background "#37474f" :foreground "Gray50"))))
 '(helm-candidate-number ((t (:background "#1c1f26" :foreground "#ffffff"))))
 '(variable-pitch ((t (:family "Ricty")))))
