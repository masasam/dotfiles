;; theme
(load-theme 'material t)
;(load-theme 'cyberpunk t) ;;#1c1f26
;;;; themeの一部分を自分好みに変更 M-x list-faces-display で調べて変更する
(custom-set-faces
 '(fixed-pitch ((t (:family "Ricty"))))
 '(elscreen-tab-background-face ((t (:background "#37474f"))))
 '(elscreen-tab-current-screen-face ((t (:background "dark slate gray" :foreground "white"))))
 '(elscreen-tab-other-screen-face ((t (:background "#37474f" :foreground "Gray50"))))
 '(helm-candidate-number ((t (:background "#1c1f26" :foreground "#ffffff"))))
 '(variable-pitch ((t (:family "Ricty")))))
