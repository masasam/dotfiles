(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=200"))
(setq flycheck-flake8-maximum-line-length 200)
(py-autopep8-enable-on-save)
