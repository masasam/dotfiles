;;; 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-long-lines-length 80)
  (setopt ellama-provider (make-llm-ollama
                           :chat-model "lucas2024/gemma-2-2b-jpn-it:q8_0"
                           :embedding-model "lucas2024/gemma-2-2b-jpn-it:q8_0")))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34java ends here
