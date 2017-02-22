(add-to-list 'Info-directory-list "~/.emacs.d/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  (apply orig-fn
         (pcase filename
           ("emacs" "emacs251-ja")
           (t filename))
         args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)
