;;; package --- 97gptel.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq gptel-model 'gemma3n:latest
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '(gemma3n:latest)))

(load "~/backup/emacs/gemini.el")

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 97gptel.el ends here
