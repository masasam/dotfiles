(setq epa-file-cache-passphrase-for-symmetric-encryption t)

(require 'org-agenda)
(push "~/Dropbox/passwd/password.org.gpg" org-agenda-files)

;; password登録
(defun addpassword ()
  (interactive)
  (find-file "~/Dropbox/passwd/password.org.gpg"))
