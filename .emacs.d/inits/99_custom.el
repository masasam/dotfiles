(add-to-list 'load-path "~/Dropbox/emacs/setting/")
(require 'setting)
;; theme
(load-theme 'material t)
;; Change part of theme to your liking.
;; Investigate by changing 'M-x list-faces-display'
(custom-set-faces '(cursor ((t (:background "#82c600"))))
		  '(helm-candidate-number ((t (:background "#1c1f26" :foreground "#ffffff")))))
