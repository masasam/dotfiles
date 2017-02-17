(setq ctags-update-command "/usr/bin/ctags")
;; if you want to update (create) TAGS manually
(autoload 'ctags-update "ctags-update" "update TAGS using ctags" t)
(require 'bind-key)
(bind-key "C-c E" 'ctags-update)
