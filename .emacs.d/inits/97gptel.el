;;; package --- 97gptel.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq gptel-model 'qwen3:30b-a3b
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '(qwen3:30b-a3b)))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 97gptel.el ends here
