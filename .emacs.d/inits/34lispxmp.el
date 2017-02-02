;; Setting to annotate the evaluation result of the expression
(require 'lispxmp)
;; Annotated by pressing C-c C-d in emacs-lisp-mode
(require 'bind-key)
(bind-key "C-c C-d" 'lispxmp emacs-lisp-mode-map)
