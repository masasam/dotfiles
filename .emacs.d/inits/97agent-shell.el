;;; 97agent-shell.el --- Codex through Agent Shell -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package agent-shell
  :commands (agent-shell agent-shell-openai-start-codex)
  :bind (("C-c A" . agent-shell))
  :config
  ;; Reuse the existing `codex login' credentials.  Inheriting Emacs' environment
  ;; also makes the mise-installed `codex-acp' executable available to the agent.
  (setq agent-shell-openai-authentication
        (agent-shell-openai-make-authentication :login t)
        agent-shell-openai-codex-environment
        (agent-shell-make-environment-variables :inherit-env t)
        agent-shell-preferred-agent-config 'codex))

(provide '97agent-shell)
;;; 97agent-shell.el ends here
