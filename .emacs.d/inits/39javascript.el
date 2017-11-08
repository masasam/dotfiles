(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\.jsx$" . js2-jsx-mode))
(flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)

(add-hook 'js2-mode-hook
          (lambda ()
	    (setq tern-command '("tern" "--no-port-file"))
            (tern-mode t)))

(add-hook 'js2-jsx-mode-hook
          (lambda ()
	    (setq tern-command '("tern" "--no-port-file"))
            (tern-mode t)))

(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))
