;;; 11markdown.el --- 11markdown.el -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq markdown-fontify-code-blocks-natively t)

(add-hook 'markdown-mode-hook
          #'(lambda () (outline-minor-mode t)))


(defun md2pdf ()
  "Generate pdf from currently open markdown."
  (interactive)
  (let* ((filename (or buffer-file-name
		       (user-error "This buffer is not visiting a file")))
	 (output (concat (file-name-sans-extension filename) ".pdf")))
    (unless (zerop (call-process "pandoc" nil nil nil
				 filename "-o" output
				 "-V" "mainfont=IPAPGothic"
				 "-V" "geometry:margin=20mm"
				 "-V" "fontsize=14pt"
				 "--pdf-engine=lualatex"))
      (user-error "Pandoc failed to generate %s" output))
    (start-process "md2pdf-open" nil "xdg-open" output)))


(defun md2docx ()
  "Generate docx from currently open markdown."
  (interactive)
  (let* ((filename (or buffer-file-name
		       (user-error "This buffer is not visiting a file")))
	 (output (concat (file-name-sans-extension filename) ".docx")))
    (unless (zerop (call-process "pandoc" nil nil nil
				 filename "-t" "docx" "-o" output
				 "-V" "mainfont=IPAPGothic"
				 "-V" "fontsize=16pt"
				 "--toc" "--highlight-style=zenburn"))
      (user-error "Pandoc failed to generate %s" output))
    (start-process "md2docx-open" nil "xdg-open" output)))


;; markdown-preview like github
(setq markdown-command "pandoc"
      markdown-command-needs-filename t
      markdown-content-type "application/xhtml+xml"
      markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
			   "http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
      markdown-xhtml-header-content "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<script src='http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre[lang] > code').forEach((code) => {
    code.classList.add(code.parentElement.lang);
    hljs.highlightBlock(code);
  });
});
</script>
")

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 11markdown.el ends here
