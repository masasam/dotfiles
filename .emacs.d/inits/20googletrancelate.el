;; google-translate
(require 'google-translate)
(use-package google-translate
  :config
  (global-set-key (kbd "C-c t") 'google-translate-at-point)

  ; en -> ja
  (custom-set-variables
    '(google-translate-default-source-language "en")
    '(google-translate-default-target-language "ja"))

  (with-eval-after-load 'popwin
    (push "*Google Translate*" popwin:special-display-config)))
