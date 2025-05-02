;;; package --- 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-long-lines-length 80)
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "qwen3:30b-a3b"
                           :embedding-model "qwen3:30b-a3b"))
  (setopt ellama-providers
        '(("gemma3" . (make-llm-ollama
                         :chat-model "gemma3:12b"
                         :embedding-model "gemma3:12b")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 98ellama.el ends here
