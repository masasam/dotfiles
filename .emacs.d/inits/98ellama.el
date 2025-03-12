;;; package --- 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-long-lines-length 80)
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "gemma3:12b"
                           :embedding-model "gemma3:12b"))
  (setopt ellama-providers
        '(("llama3.2" . (make-llm-ollama
                         :chat-model "deepseek-r1:14b"
                         :embedding-model "deepseek-r1:14b")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 98ellama.el ends here
