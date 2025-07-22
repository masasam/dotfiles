;;; package --- 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-long-lines-length 80)
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "gemma3n:latest"
                           :embedding-model "gemma3n:latest")))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 98ellama.el ends here
