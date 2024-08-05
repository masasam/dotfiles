;;; 98ellama.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(with-eval-after-load 'llm
  (require 'llm-ollama)
  (setopt ellama-language "Japanese")
  (setopt ellama-translation-provider (make-llm-ollama
                                       :chat-model "aya:8b"
                                       :embedding-model "aya:8b"))
)

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 34java ends here
