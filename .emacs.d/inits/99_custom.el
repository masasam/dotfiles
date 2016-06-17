;; theme
(load-theme 'material t)
;(load-theme 'cyberpunk t) ;;#1c1f26
;;;; themeの一部分を自分好みに変更 M-x list-faces-display で調べて変更する
(custom-set-faces
 '(fixed-pitch ((t (:family "Ricty"))))
 '(helm-candidate-number ((t (:background "cornflower blue" :foreground "#ffffff"))))
 '(variable-pitch ((t (:family "Ricty")))))


(setq custom-file "~/.emacs.d/custom-file.el")
(if (file-exists-p (expand-file-name "~/.emacs.d/custom-file.el"))
    (load (expand-file-name custom-file) t nil nil))
