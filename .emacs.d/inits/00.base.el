;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;; Reduce GC to speed up (eat memory)
(setq gc-cons-threshold (* 128 1024 1024))


;;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)


;; font
(add-to-list 'default-frame-alist '(font . "ricty-15.5"))


;; It does not end with C-x C-c
(global-set-key (kbd "C-x C-c") 'helm-M-x)

;; Perform M % with C-c r
(global-set-key (kbd "C-c r") 'query-replace)

;; I never use C-x C-c
(defalias 'exit 'save-buffers-kill-emacs)


; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))


;; Do not make a backup file like *.~
(setq make-backup-files nil)
;; Do not make a backup file like .#*
(setq auto-save-default nil)


;; C-h is backspace
(define-key global-map "\C-h" 'delete-backward-char)

;; Enable backspace key in incremental search minibuffer
(define-key isearch-mode-map "\C-h" 'isearch-delete-char)

;; Assign the function help-command assigned to C-h to C-x C-h
(define-key global-map "\C-x\C-h" 'help-command)

;; Run C-x C-k same kill-buffer as C-x k
(define-key global-map "\C-x\C-k" 'kill-buffer)

;; C-x C-d also makes dired
(global-set-key (kbd "C-x C-d") 'dired)

;; minibuffer-local-completion-mpa
(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)

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
(setq select-enable-clipboard t)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-w" 'clipboard-kill-region)


;; Brace the corresponding parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)


;; Dired files deleted by trash
(setq delete-by-moving-to-trash t)


;; Continue hitting C-SPC and go back to past marks ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Read elisp function source file
(global-set-key (kbd "C-x F") 'find-function)
(global-set-key (kbd "C-x V") 'find-variable)
;; emacs c source dir:
(setq find-function-C-source-directory "~/Dropbox/emacs/emacs-25.1/emacs-25.1/src")
