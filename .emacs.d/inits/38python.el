(elpy-enable)
(setq elpy-rpc-backend "jedi")
(add-hook 'python-mode-hook (lambda () (auto-complete-mode -1)))
