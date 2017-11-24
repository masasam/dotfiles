;; direx
(require 'direx)
(require 'direx-project)

(defun my/dired-jump ()
  (interactive)
  (cond (current-prefix-arg
         (dired-jump))
        ((not (one-window-p))
         (or (ignore-errors
               (direx-project:jump-to-project-root) t)
             (direx:jump-to-directory)))
        (t
         (or (ignore-errors
               (direx-project:jump-to-project-root-other-window) t)
             (direx:jump-to-directory-other-window)))))

(bind-key "C-x C-j" 'my/dired-jump)
(bind-key "C-x j" 'my/dired-jump)

;; Adjust width according to the environment.
(push '(direx:direx-mode :position left :width 40 :dedicated t)
      popwin:special-display-config)
