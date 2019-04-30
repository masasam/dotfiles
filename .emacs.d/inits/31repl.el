;;; 31repl.el --- 31repl.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(require 'python)
(defvar my/elpy--shell-last-py-buffer nil
  "Help keep track of python buffer when changing to pyshell.")


(defun my/python-shell-switch-to-shell ()
  "Switch to inferior Python process buffer."
  (interactive)
  (setq my/elpy--shell-last-py-buffer (buffer-name))
  (pop-to-buffer (process-buffer (my/elpy-shell-get-or-create-process))))


(defun my/elpy-shell-get-or-create-process (&optional sit)
  "Get or create an inferior Python process for current buffer and return it.

If SIT is non-nil, sit for that many seconds after creating a
Python process. This allows the process to start up."
  (let* ((bufname (format "*%s*" (python-shell-get-process-name nil)))
	 (proc (get-buffer-process bufname)))
    (if proc
	proc
      (when (not (executable-find python-shell-interpreter))
	(error "Python shell interpreter `%s' cannot be found. Please set `python-shell-interpreter' to an valid python binary."
	       python-shell-interpreter))
      (let ((default-directory default-directory))
	(run-python (python-shell-parse-command) nil t))
      (when sit (sit-for sit))
      (python-shell-send-string
       (format "import sys;sys.path.append('%s')" (elpy-project-root)))
      (get-buffer-process bufname))))


;; repl-toggle
(setq rtog/fullscreen t)
(require 'repl-toggle)
(setq rtog/mode-repl-alist '((js2-mode . nodejs-repl) (emacs-lisp-mode . ielm) (ruby-mode . inf-ruby) (python-mode . my/python-shell-switch-to-shell)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 31repl.el ends here
