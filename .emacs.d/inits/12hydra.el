(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-vertically))
  (other-window 1))


(defhydra hydra-git-gutter (ctl-x-map "" :pre (widen))
  "page"
  ("0" delete-window "delete")
  ("x" delete-window "delete")
  ("1" delete-other-windows "delete other")
  ("2" split-window-below "split-h")
  ("3" split-window-right "split-v")
  ("," shrink-window-horizontally "enlarge")
  ("." enlarge-window-horizontally "enlarge")
  ("+" shrink-window "shrink")
  ("-" enlarge-window "enlarge")
  ("o" other-window-or-split "split")
  ("n" git-gutter:next-hunk "next-hunk")
  ("p" git-gutter:previous-hunk "prev-hunk"))


;; hydra-view-mode
(defhydra hydra-view-mode (:hint nil :exit t)
  "
^View-mode

_j_: next-line   _k_: previous-line    _h_: one line    _l_: forward-char  _i_: view-mode
_g_: beginning-of-buffer   _G_: end-of-buffer  _a_: beginning-of-line   _e_: end-of-line
_b_: delete-window   _x_: delite-window   _0_: delete-window   _1_: delete-other-windows
_n_: scroll-up-command   _p_: scroll-down-command   _u_: View-scroll-half-page-backward
_2_: other-window-or-split   _d_: View-scroll-half-page-forward   _._: set-mark-command
_/_: swiper-for-region-or-swiper  _f_: View-scroll-line-forward   _@_: View-back-to-mark
_3_: other-window-or-split-horizon  _o_:  other-window-or-split   _%_: View-goto-percent
_d_: View-scroll-half-page-forward  _c_: View-kill-and-leave   _=_: what-line
"
  ("j" 'next-line)
  ("k" 'previous-line)
  ("h" 'backward-char)
  ("l" 'forward-char)
  ("i" 'view-mode)
  ("g" 'beginning-of-buffer)
  ("G" 'end-of-buffer)
  ("e" 'end-of-line)
  ("a" 'beginning-of-line)
  ("n" 'scroll-up-command)
  ("p" 'scroll-down-command)
  ("o" 'other-window-or-split)
  ("f" 'View-scroll-line-forward)
  ("b" 'View-scroll-line-backward)
  ("x" 'delete-window)
  ("u" 'View-scroll-half-page-backward)
  ("d" 'View-scroll-half-page-forward)
  ("c" 'View-kill-and-leave)
  ("@" 'View-back-to-mark)
  ("." 'set-mark-command)
  ("%" 'View-goto-percent)
  ("=" 'what-line)
  ("0" 'delete-window)
  ("1" 'delete-other-windows)
  ("2" 'other-window-or-split)
  ("3" 'other-window-or-split-horizontally)
  ("/" 'swiper-for-region-or-swiper))
