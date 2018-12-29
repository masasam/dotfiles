;;; 08mew.el --- 08mew.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

;; mew
(load "~/Dropbox/emacs/secret.el")
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(require 'mew)
(setq mail-user-agent 'mew-user-agent)
(define-mail-user-agent
  'mew-user-agent
  'mew-user-agent-compose
  'mew-draft-send-message
  'mew-draft-kill
  'mew-send-hook)

(setq mew-smtp-server "smtp.gmail.com")
(setq mew-prog-ssl "/usr/bin/stunnel")
(setq mew-proto "%")
(setq mew-imap-server "imap.gmail.com")
(setq mew-imap-auth  t)
(setq mew-imap-ssl t)
(setq mew-imap-ssl-port "993")
(setq mew-smtp-auth t)
(setq mew-smtp-ssl t)
(setq mew-smtp-ssl-port "465")
(setq mew-smtp-server "smtp.gmail.com")
(setq mew-fcc "%Sent")
(setq mew-imap-trash-folder "%[Gmail]/ゴミ箱")
(setq mew-use-cached-passwd t)
(setq mew-use-master-passwd t)
(setq mew-ssl-verify-level 0)
(setq mew-use-unread-mark t)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 08mew.el ends here
