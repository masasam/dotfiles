;; theme
(load-theme 'material t)
;; Change part of theme to your liking.
;; Investigate by changing 'M-x list-faces-display'
(custom-set-faces '(cursor ((t (:background "#82c600")))))


;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;; exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(setq exec-path-from-shell-check-startup-files nil)


;;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)


;; font
(add-to-list 'default-frame-alist '(font . "Cica-15.5"))


;; defalias list
(defalias 'my/keybind 'counsel-descbinds)
(defalias 'my/github 'browse-at-remote)


;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))


;; Do not make a backup file like *.~
(setq make-backup-files nil)
;; Do not use auto save
(setq auto-save-default nil)
;; Do not create lock file
(setq create-lockfiles nil)


;; C-h is backspace
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; Run C-x C-k same kill-buffer as C-x k
(require 'bind-key)
(bind-key "C-x C-k" 'kill-buffer)


;; Assign ibuffer to C-x C-b
(bind-key "C-x C-b" 'ibuffer)


;; Set bookmark file name
(setq bookmark-file "~/Dropbox/emacs/bookmarks")

;; minibuffer-local-completion-mpa
(bind-key "C-w" 'backward-kill-word minibuffer-local-completion-map)

;; When the mouse cursor is close to the text cursor, the mouse hangs away
(if (display-mouse-p) (mouse-avoidance-mode 'exile))

;; Disable automatic save
(setq auto-save-default nil)

;; Display file name in title bar
(setq frame-title-format (format "Emacs@%s : %%f" (system-name)))

;; Do not distinguish uppercase and lowercase letters on completion
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Make it easy to see when it is the same name file
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Display the character position of the cursor
(column-number-mode t)

;; Increase history count
(setq history-length 10000)

;; Save history of minibuffer
(savehist-mode 1)

;; Make "yes or no" "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; Turn off warning sound screen flash
(setq visible-bell nil)
;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
(setq ring-bell-function 'ignore)

;; It keeps going steadily past the mark ...C-x C-SPC C-SPC
;; It keeps going steadily past the mark ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Use the X11 clipboard
(setq select-enable-clipboard  t)
(bind-key "M-w" 'clipboard-kill-ring-save)
(bind-key "C-w" 'clipboard-kill-region)


;; Brace the corresponding parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)


;; Dired files deleted by trash
(setq delete-by-moving-to-trash t)


;; Continue hitting C-SPC and go back to past marks ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; emacs c source dir:
(setq find-function-C-source-directory "~/Dropbox/emacs/emacs-25.3/src")


;; Do not change the position of the cursor on the screen as much as possible when scrolling pages
(setq scroll-preserve-screen-position t)


;; contain many mode setting
(require 'generic-x)


;; mytimer
(defun my/timer(n)
  (interactive "nMinute:")
  (run-at-time (* n 60) nil #'_mytimer))
(defun _mytimer()
  (shell-command-to-string "notify-send -u critical 'Emacs' 'It is time' -i utilities-terminal"))


(defun my/copy-path ()
  (interactive)
  (if buffer-file-name
      (progn
	(kill-new (file-truename buffer-file-name))
	(message (buffer-file-name)))
    (progn
      (kill-new default-directory)
      (message default-directory))))


(defun my/active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc (lambda (mode) (condition-case nil
                             (if (and (symbolp mode) (symbol-value mode))
                                 (add-to-list 'active-modes mode))
                           (error nil) ))
          minor-mode-list)
    (message "Active modes are %s" active-modes)))


;; M-x info-emacs-manual(C-h r)
(add-to-list 'Info-directory-list "~/.emacs.d/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  (apply orig-fn
         (pcase filename
           ("emacs" "emacs-ja")
           (_ filename))
         args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)


;; Mutt support.
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))


;; Color when emacs is not focused
(defun my-out-focused-mode-line()
  (set-face-background 'mode-line "#2f4f4f"))
;; Color when emacs is focused
(defun my-in-focused-mode-line()
  (set-face-background 'mode-line "#1c1f26"))
(add-hook 'focus-out-hook 'my-out-focused-mode-line)
(add-hook 'focus-in-hook 'my-in-focused-mode-line)


(defun trash-list ()
  "Show trash-list."
  (interactive)
  (find-file "~/.local/share/Trash/files"))


(defun trash-empty ()
  "Make trash empty."
  (interactive)
  (shell-command-to-string "trash-empty"))
