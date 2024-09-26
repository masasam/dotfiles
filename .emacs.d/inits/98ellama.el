;;; 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "llama3.2:1b"
                           :embedding-model "llama3.2:1b")))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34java ends here
