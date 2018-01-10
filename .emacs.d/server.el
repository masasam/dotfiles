;;; default.el --- default.el
;;; Commentary:
;;; Code:
(package-initialize)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(load-theme 'misterioso t)

;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)


;;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)


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
(define-key global-map (kbd "C-x C-k") 'kill-buffer)


;; minibuffer-local-completion-mpa
(define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word)

;; When the mouse cursor is close to the text cursor, the mouse hangs away
(if (display-mouse-p) (mouse-avoidance-mode 'exile))

;; Disable automatic save
(setq auto-save-default nil)

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
(define-key global-map (kbd "M-w") 'clipboard-kill-ring-save)
(define-key global-map (kbd "C-w") 'clipboard-kill-region)


;; Brace the corresponding parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)


;; Continue hitting C-SPC and go back to past marks ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Read elisp function source file
(define-key global-map (kbd "C-x F") 'find-function)
(define-key global-map (kbd "C-x V") 'find-variable)


;; Highlight the space at the end of the line
(setq-default show-trailing-whitespace t)


;; Do not change the position of the cursor on the screen as much as possible when scrolling pages
(setq scroll-preserve-screen-position t)


;; contain many mode setting
(require 'generic-x)
