;;; 3つの表示方法どれか1つ選ぶ
(which-key-setup-side-window-bottom)    ;ミニバッファ
;; (which-key-setup-side-window-right)     ;右端
;; (which-key-setup-side-window-right-bottom) ;両方使う

(which-key-mode 1)

;; c-x c-hとかぶるから消す(?で呼び出す)
(setq which-key-use-C-h-commands nil)
