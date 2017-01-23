(require 'sql-indent)
(eval-after-load "sql"
  '(load-library "sql-indent"))

(defun sql-mode-hooks()
  (setq sql-indent-offset 2)
  (setq indent-tabs-mode nil)
  (sql-set-product "postgres"))

(add-hook 'sql-mode-hook 'sql-mode-hooks)
