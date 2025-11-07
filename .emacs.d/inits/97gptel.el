;;; package --- 97gptel.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq gptel-default-mode 'org-mode)

(setq gptel-model 'gemma3n:latest
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '(gemma3n:latest)))

(bind-key "C-c C-g" 'gptel-send)

(load "~/backup/emacs/gemini.el")

(use-package gptel-commit
  :ensure t
  :after (gptel magit)
  :custom
  (gptel-commit-stream t))

(with-eval-after-load 'magit
  (define-key git-commit-mode-map (kbd "C-c g") #'gptel-commit)
  (define-key git-commit-mode-map (kbd "C-c G") #'gptel-commit-rationale))

(use-package gptel-magit
  :ensure t
  :hook (magit-mode . gptel-magit-install))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 97gptel.el ends here
