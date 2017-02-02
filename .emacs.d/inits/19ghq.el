(add-to-list 'helm-for-files-preferred-list 'helm-source-ghq)
(require 'bind-key)
(bind-key "C-x l" 'helm-ghq)
(bind-key "C-x C-l" 'helm-ghq)
