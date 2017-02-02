;; magit
(autoload 'magit-status "magit" nil t)
(require 'bind-key)
(bind-key "C-x g" 'magit-status)
