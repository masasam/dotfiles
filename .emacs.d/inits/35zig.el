;;; 35zig.el --- Zig language support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(use-package zig-mode
  :mode ("\\.zig\\'" . zig-mode)
  :hook (zig-mode . eglot-ensure)
  :custom
  ;; Apheleia handles formatting, so avoid formatting the buffer twice.
  (zig-format-on-save nil))

(with-eval-after-load 'eglot
  (let ((zig-executable (executable-find "zig")))
    (when zig-executable
      (add-to-list
	'eglot-server-programs
	`(zig-mode . ("zls" :initializationOptions
		      (:zig_exe_path ,zig-executable)))))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 35zig.el ends here
