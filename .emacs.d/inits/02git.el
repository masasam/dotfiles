;;; 02git.el --- 02git.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(use-package magit
  :config
  (require 'magit-extras)
  :bind
  (("C-x g" . magit-status)
   ("C-x G" . magit-blame)))

;; keychain-environment
(keychain-refresh-environment)

(defun my/remoto-use-gh-auth (&rest _)
  "Use the existing GitHub CLI credential for Remoto when none is configured.
Keep the credential in memory; never save it through Custom or log it."
  (when (and (boundp 'remoto-github-auth)
             (null remoto-github-auth)
             (executable-find "gh"))
    (let ((default-directory (expand-file-name "~/")))
      (with-temp-buffer
        (when (eq 0 (call-process "gh" nil (list (current-buffer) nil) nil
                                  "auth" "token" "--hostname" "github.com"))
          (let ((token (string-trim (buffer-string))))
            (unless (string-empty-p token)
              (setq remoto-github-auth token))))))))

(defun my/remoto-quiet-auth-success (original &rest args)
  "Hide only Remoto's successful warm-up message, preserving errors."
  (let ((original-message (symbol-function 'message)))
    (cl-letf (((symbol-function 'message)
               (lambda (format-string &rest values)
                 (unless (equal format-string "Remoto: authenticated as %s")
                   (apply original-message format-string values)))))
      (apply original args))))

(with-eval-after-load 'remoto
  (advice-add 'remoto--warm-auth :before #'my/remoto-use-gh-auth)
  (advice-add 'remoto--warm-auth :around #'my/remoto-quiet-auth-success)
  (my/remoto-use-gh-auth))


(use-package diff-hl
  :init
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode)
  (global-diff-hl-show-hunk-mouse-mode)
  (diff-hl-margin-mode))


(use-package difftastic
  :config
  (difftastic-bindings-mode))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 02git.el ends here
