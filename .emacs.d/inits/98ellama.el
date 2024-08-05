;;; 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "lucas2024/llama-3-elyza-jp-8b:q5_k_m"
                           :embedding-model "lucas2024/llama-3-elyza-jp-8b:q5_k_m")))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34java ends here
