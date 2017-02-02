(require 'quickrun)
(push '("*quickrun*") popwin:special-display-config)
(require 'bind-key)
(bind-key "<f5>" 'quickrun)
