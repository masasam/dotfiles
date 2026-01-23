;;; package --- 97gptel.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq gptel-default-mode 'markdown-mode)

;; You can switch models with getel-menu using the -m option.
;; The one at the bottom defaults. gemma3n is for offline use only.
(setq gptel-model 'gemma3n:latest
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '(gemma3n:latest)))

(setq gptel-model 'gemini-flash-lite-latest
	  gptel-backend (gptel-make-gemini "Gemini"
                 :key (exec-path-from-shell-copy-env "GEMINIAPIKEY")
                 :stream t))

(use-package gptel-commit
  :after (gptel magit)
  :custom
  (gptel-commit-stream t))

(with-eval-after-load 'magit
  (define-key git-commit-mode-map (kbd "C-c g") #'gptel-commit)
  (define-key git-commit-mode-map (kbd "C-c G") #'gptel-commit-rationale))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 97gptel.el ends here
