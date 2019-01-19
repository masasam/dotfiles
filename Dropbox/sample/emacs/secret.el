;; for slack
(slack-register-team
 :name "yourslackteam"
 :default t
 :client-id "***********.***********"
 :client-secret "**********************"
 :token "xoxp-***********-***********-***********-**********************"
 :subscribed-channels '(general random)
 :full-and-display-names t)


;; for mew
(setq user-mail-address "yourgmailaddress@gmail.com")
(setq user-full-name "Yourfirstname Yourlastname")
(setq mew-imap-user "yourgmailaddress@gmail.com")
(setq mew-smtp-user "yourgmailaddress@gmail.com")
