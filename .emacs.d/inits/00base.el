;;; base.el --- base.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; theme
;; (load-theme 'material t)
(load-theme 'dracula t)
;; (load-theme 'catppuccin :no-confirm)

(setq-default tab-width 4)

(setq inhibit-startup-buffer-menu t)

;; Change part of theme to your liking.
;; Investigate by changing 'M-x list-faces-display'
(custom-set-faces '(cursor ((t (:background "#82c600")))))

;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; unused key
(global-unset-key [C-wheel-up])
(global-unset-key [C-wheel-down])
(global-unset-key [C-mouse-4])
(global-unset-key [C-mouse-5])

;; exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(setq exec-path-from-shell-check-startup-files nil)


;;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)


;; font
(add-to-list 'default-frame-alist '(font . "Cica-25"))


;; defalias list
(defalias 'my/key-binding 'counsel-descbinds)
(defalias 'my/github-show 'browse-at-remote)
(defalias 'my/ruler-show 'fci-mode)
(defalias 'my/kukei-mark-mode 'rectangle-mark-mode)

;; browse-at-remote
(setq browse-at-remote-prefer-symbolic nil)

;; espy
(setq espy-password-file "~/backup/passwd/password.org.gpg")


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
;; Open symbolic link directly
(setq vc-follow-symlinks t)


;; C-h is backspace
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))

;; Run C-x C-k same kill-buffer as C-x k
(require 'bind-key)
(bind-key "C-x C-k" 'kill-buffer)


;; Set bookmark file name
(setq bookmark-file "~/backup/emacs/bookmarks")

;; xref-find-references key
(bind-key "M-/" 'xref-find-references)

;; When the mouse cursor is close to the text cursor, the mouse pointer move to a place where does not get in the way
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

;;  Point keeps its screen position when scroll
(setq scroll-preserve-screen-position :always)

;; Turn off warning sound screen flash
(setq visible-bell nil)
;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
(setq ring-bell-function 'ignore)

;; It keeps going steadily the local mark ...  C-u C-SPC C-SPC
;; It keeps going steadily the global mark ... C-x C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; Use the X11 clipboard
(setq select-enable-clipboard  t)
(bind-key "M-w" 'clipboard-kill-ring-save)
(bind-key "C-w" 'my/clipboard-kill-region)
(bind-key "C-x C-x" 'my/exchange-point-and-mark)
(bind-key "M-c" 'my/capitalize-word)
(bind-key "M-l" 'my/downcase-word)
(bind-key "M-u" 'my/upcase-word)


(defun my/clipboard-kill-region ()
  "If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
  (interactive)
  (if (use-region-p)
      (clipboard-kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))


(defun my/exchange-point-and-mark ()
  "No mark active `exchange-point-and-mark'."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark))


(defun my/upcase-word (arg)
  "Convert previous word (or ARG words) to upper case."
  (interactive "p")
  (upcase-word (- arg)))


(defun my/downcase-word (arg)
  "Convert previous word (or ARG words) to down case."
  (interactive "p")
  (downcase-word (- arg)))


(defun my/capitalize-word (arg)
  "Convert previous word (or ARG words) to capitalize."
  (interactive "p")
  (capitalize-word (- arg)))


;; Brace the corresponding parentheses
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)


;; Continue hitting C-SPC and go back to past marks ...C-u C-SPC C-SPC
(setq set-mark-command-repeat-pop t)


;; emacs c source dir:
;; (setq find-function-C-source-directory "~/backup/emacs/emacs-29.2/src")


;; Do not change the position of the cursor on the screen as much as possible when scrolling pages
(setq scroll-preserve-screen-position t)


;; contain many mode setting
(require 'generic-x)


;; tramp with ControlPath
(customize-set-variable
 'tramp-ssh-controlmaster-options
 (concat
  "-o ControlPath=~/.ssh/master-%%r@%%h:%%p "
  "-o ControlMaster=auto -o ControlPersist=30m"))

;; (customize-set-variable 'tramp-use-ssh-controlmaster-options nil)


(defun my/copy-path ()
  "Return the currently open file name or directory name."
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


;; M-x info-emacs-manual
(add-to-list 'Info-directory-list (expand-file-name "info" user-emacs-directory))
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  "Info as ORIG-FN FILENAME ARGS."
  (apply orig-fn
         (pcase filename
           ("emacs" "emacs-ja")
           (_ filename))
         args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)


;; Mutt support.
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))


(defun firebase-deploy ()
  "Firebase deploy command."
  (interactive)
  (shell-command-to-string "firebase login")
  (message "Logined")
  (shell-command-to-string "firebase deploy")
  (message "Published"))


(defun sylpheed ()
  "Open sylpheed."
  (interactive)
  (shell-command-to-string "sylpheed %u"))


(defun my/duplicate-current-line (&optional n)
  "Duplicate current line, make more than 1 copy given a N argument."
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
	  (current-line (thing-at-point 'line)))
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
	(insert "\n"))
      (while (> n 0)
	(insert current-line)
	(decf n)))))

(bind-key "C-M-y" 'my/duplicate-current-line)

(setq eww-search-prefix "https://www.google.co.jp/search?q=")

;; avy
(bind-key "C-r" 'avy-goto-word-1)

;; dmacro
(use-package dmacro
  :ensure t
  :init
  (setq dmacro-key (kbd "C-t"))
  (global-dmacro-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 00base.el ends here
