;;; 15easy-hugo.el --- 15easy-hugo.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(setq easy-hugo-url "https://solist.work/blog")
(setq easy-hugo-basedir "~/src/github.com/masasam/solistblog/")
(setq easy-hugo-postdir "content/posts")
(setq easy-hugo-server-flags "-b")
(setq easy-hugo-server-value "localhost")
(setq easy-hugo-previewtime "300")
(setq easy-hugo-default-picture-directory "~/Pictures")
(define-key global-map (kbd "C-c C-e") 'easy-hugo)

(setq easy-hugo-bloglist '(((easy-hugo-basedir . "~/src/github.com/masasam/solist/")
			    (easy-hugo-url . "https://solist.work")
			    (easy-hugo-postdir . "content/services"))
			   ((easy-hugo-basedir . "~/src/github.com/masasam/PPAP/")
			    (easy-hugo-url . "https://easy-hugo-test.firebaseapp.com")
			    (easy-hugo-postdir . "content/post"))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 15easy-hugo.el ends here
