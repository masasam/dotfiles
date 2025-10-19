;;; 06hydra.el --- 06hydra.el

;;; Code:
;;(setq debug-on-error t)

(defun other-window-or-split ()
  "If there is one window, open split window.
If there are two or more windows, it will go to another window."
  (interactive)
  (when (one-window-p)
    (split-window-vertically))
  (other-window 1))


(defun other-window-or-split-horizontally ()
  "If there is one window, open split window horizontally.
If there are two or more windows, it will go to another window."
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))


;; key-chord
(setq key-chord-two-keys-delay 0.1)
(key-chord-mode 1)
(bind-key "C-'" 'hydra-pinky/body)


(key-chord-define-global
 "jk"
 (defhydra hydra-pinky
   ()
   "pinky"
   ("n" next-line)
   ("p" previous-line)
   ("f" forward-char)
   ("b" backward-char)
   ("a" beginning-of-line)
   ("e" move-end-of-line)
   ("v" scroll-up-command)
   ("V" scroll-down-command)
   ("g" keyboard-quit)
   ("j" diff-hl-next-hunk)
   ("k" diff-hl-previous-hunk)
   ("o" other-window-or-split)
   ("r" avy-goto-word-1)
   ("l" recenter-top-bottom)
   ("s" consult-line-or-region)
   ("S" window-swap-states)
   ("q" kill-buffer)
   ("w" clipboard-kill-ring-save)
   ("<" beginning-of-buffer)
   (">" end-of-buffer)
   ("SPC" set-mark-command)
   ("\C-m" dired-find-file)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("0" delete-window)
   ("x" delete-window)
   (";" consult-buffer)
   ("M-n" next-buffer)
   ("M-p" previous-buffer)))


(defhydra hydra-ctrl-x (ctl-x-map "" :pre (widen))
  "ctrl-x"
  ("0" delete-window)
  ("x" delete-window)
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("o" other-window-or-split)
  ("S" window-swap-states)
  ("n" flymake-goto-next-error)
  ("p" flymake-goto-prev-error))


(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")
  ("r" (text-scale-set 0) "reset"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 06hydra.el ends here
