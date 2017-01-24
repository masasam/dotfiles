(require 'sql)
(require 'sql-indent)

(setq auto-mode-alist
      (cons '("\\.sql$" . sql-mode) auto-mode-alist))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))
