;;; 11markdown.el --- 11markdown.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq markdown-fontify-code-blocks-natively t)

(add-hook 'markdown-mode-hook
          #'(lambda () (outline-minor-mode t)))


(defun md2pdf ()
  "Generate pdf from currently open markdown."
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
    (call-process-shell-command
     (concat "pandoc "
	     filename
	     " -o "
	     (file-name-sans-extension filename)
	     ".pdf -V mainfont=IPAPGothic -V geometry:margin=20mm -V fontsize=14pt --pdf-engine=lualatex"))
    (call-process-shell-command
     (concat "xdg-open "
	     (file-name-sans-extension filename)
	     ".pdf"))))


(defun md2docx ()
  "Generate docx from currently open markdown."
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
    (call-process-shell-command
     (concat "pandoc "
	     filename
	     " -t docx -o "
	     (file-name-sans-extension filename)
	     ".docx -V mainfont=IPAPGothic -V fontsize=16pt --toc --highlight-style=zenburn"))
    (call-process-shell-command
     (concat "xdg-open "
	     (file-name-sans-extension filename)
	     ".docx"))))


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
