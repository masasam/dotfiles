;;; package --- 97gptel.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq gptel-default-mode 'markdown-mode)

(defun my/gptel-gemini-api-key ()
  "Read the Gemini key on the first request that needs it."
  (or (getenv "GEMINI_API_KEY")
      (exec-path-from-shell-copy-env "GEMINI_API_KEY")
      (user-error "GEMINI_API_KEY is not set")))

(with-eval-after-load 'gptel
  (gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t
    :models '(gemma4:e4b))
  (setq gptel-model 'gemini-flash-lite-latest
        gptel-backend (gptel-make-gemini "Gemini"
                        :key #'my/gptel-gemini-api-key
                        :stream t)))

(use-package gptel-commit
  :defer t
  :custom
  (gptel-commit-stream t))

(with-eval-after-load 'git-commit
  (define-key git-commit-mode-map (kbd "C-c g") #'gptel-commit)
  (define-key git-commit-mode-map (kbd "C-c G") #'gptel-commit-rationale))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 97gptel.el ends here
