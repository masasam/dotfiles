;;; 06hydra.el --- 06hydra.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(defun other-window-or-split ()
  "If there is one window, open another window.
If there are two or more windows, it will go to another window."
  (interactive)
  (when (one-window-p)
    (split-window-vertically))
  (other-window 1))


(defun other-window-or-split-horizontally ()
  "If there is one window, open another window.
If there are two or more windows, it will go to another window."
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))


;; key-chord
(setq key-chord-two-keys-delay 0.04)
(key-chord-mode 1)
(bind-key "C-'" 'hydra-move/body)


(key-chord-define-global
 "jk"
 (defhydra hydra-move
   (:body-pre)
   "move"
   ("n" next-line)
   ("p" previous-line)
   ("f" forward-char)
   ("b" backward-char)
   ("a" beginning-of-line)
   ("e" move-end-of-line)
   ("v" scroll-up-command)
   ("V" scroll-down-command)
   ("l" recenter-top-bottom)
   ("s" swiper-for-region-or-swiper)
   ("0" delete-window)
   ("x" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("o" other-window-or-split)
   ("<" beginning-of-buffer)
   (">" end-of-buffer)
   ("SPC" set-mark-command)
   ("S" window-swap-states)
   ("j" git-gutter:next-hunk)
   ("k" git-gutter:previous-hunk)))


(defhydra hydra-window (ctl-x-map "" :pre (widen))
  "page"
  ("0" delete-window)
  ("x" delete-window)
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("o" other-window-or-split)
  ("S" window-swap-states))


(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")
  ("r" (text-scale-set 0) "reset"))

;;; 06hydra.el ends here
