;;
;;      dmacro.el - キー操作の繰返し検出 & 実行
;;
;;      1993 4/14        original idea by 増井俊之＠シャープ
;;                         implemented by 太和田誠＠長岡技科大
;;                          refinement by 増井俊之＠シャープ
;;	1995 3/30 modified for Emacs19 by 増井俊之＠シャープ
;;
;;      $Date: 2004-10-13 09:02:05 +0900 (Wed, 13 Oct 2004) $
;;      $Revision: 22 $
;;
;; dmacro.el は、繰り返されるキー操作列から次の操作を予測し実行させる
;; ためのプログラムです。操作の繰返しの検出とその実行を指令するために
;; *dmacro-key* で指定する特別の「繰返しキー」を使用します。
;; 
;; 例えばユーザが
;;     abcabc
;; と入力した後「繰返しキー」を押すと、dmacro.el は "abc" の入力操作の
;; 繰返しを検出してそれを実行し、その結果テキストは
;;     abcabcabc
;; となります。また、
;;     abcdefab
;; と入力した後「繰返しキー」を押すと、dmacro.el はこれを "abcdef" の
;; 入力の繰返しと判断し、繰返しの残りの部分を予測実行して "cdef" を入力し、
;; テキストは
;;     abcdefabcdef
;; となります。ここでもう一度「繰返しキー」を押すと、"abcdef" の入力
;; が繰り返されて、テキストは
;;     abcdefabcdefabcdef
;; となります。
;; 
;; あらゆるキー操作の繰返しが認識、実行されるため、例えば
;;     line1
;;     line2
;;     line3
;;     line4
;; というテキストを
;;     % line1
;;     % line2
;;     line3
;;     line4
;; のように編集した後「繰返しキー」を押すとテキストは
;;     % line1
;;     % line2
;;     % line3
;;     line4
;; のようになり、その後押すたびに次の行頭に "% "が追加されていきます。
;; 
;; このような機能は、繰返しパタンの認識によりキーボードマクロを自動的に
;; 定義していると考えることもできます。キーボードマクロの場合は操作を
;; 開始する以前にそのことをユーザが認識してマクロを登録する必要があり
;; ますが、dmacro.el では実際に繰返し操作をしてしまった後でそのことに
;; 気がついた場合でも「繰返しキー」を押すだけでその操作をまた実行させる
;; ことができます。またマクロの定義方法(操作の後で「繰返しキー」を押す
;; だけ)もキーボードマクロの場合(マクロの開始と終了を指定する)に比べて
;; 単純になっています。
;;  
;; ● 使用例
;;  
;; ・文字列置換
;; 
;; テキスト中の全ての「abc」を「def]に修正する場合を考えてみます。
;; 「abc」を検索するキー操作は "Ctrl-S a b c ESC" で、これは
;; "DEL DEL DEL d e f" で「def」に修正することができます。
;; 引き続き次の「abc」を検索する "Ctrl-S a b c ESC" を入力した後で
;; 「繰返しキー」を押すと "DEL DEL DEL d e f" が予測実行され、新たに
;; 検索された「abc」が「def」に修正されます。ここでまた「繰返しキー」
;; を押すと次の「abc」が「def」に修正されます。
;; このように「繰返しキー」を押していくことにより順々に文字列を
;; 置換していくことができます。
;; 
;; ・罫線によるお絵書き
;; 
;; 繰返しを含む絵を簡単に書くことができます。例えば、
;;   ─┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐┌┐
;;     └┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘└┘
;; のような絵を書きたい場合は、keisen.el などを使って
;;   ─┐┌┐
;;     └┘
;; と書いた後で「繰返し」キーを押すと、
;;   ─┐┌┐
;;     └┘└┘
;; となり、もう一度「繰返しキー」を押すと
;;   ─┐┌┐┌┐
;;     └┘└┘└┘
;; となります。同様に
;;  ┌─┐┌─┐┌─┐┌─┐┌─┐┌─┐┌─┐┌─┐
;;  └─┘└─┘└─┘└─┘└─┘└─┘└─┘└─┘
;; のような絵も
;;  ┌─┐  ─
;;  └─┘
;; だけ入力した後「繰返しキー」を連続して押すだけで描くことができます。
;;  
;; ● 繰返し予測の方法
;;  
;; 入力の繰返しの予測手法はいろいろ考えられますが、dmacro.elでは
;; 以下のような優先度をもたせています。
;; 
;;  (1) 同じ入力パタンが予測の直前に2度繰返されている場合はそれを
;;      優先する。繰返しパタンが複数ある場合は長いものを優先する。
;; 
;;      例えば、「かわいいかわいい」という入力では「かわいい」と
;;      いうパタンが繰り返されたという解釈と、「い」というパタンが
;;      繰り返されたという解釈の両方が可能ですが、この場合
;;      「かわいい」を優先します。
;; 
;;  (2) (1)の場合にあてはまらず、直前の入力列<s>がそれ以前の入力列の
;;      一部になっている場合(直前の入力が<s> <t> <s>のような形に
;;      なっている場合)は、まず<t>を予測し、その次から<s> <t>を予測
;;      する。このとき<s>の長いものを優先し、その中では<t>が短いもの
;;      を優先する。
;; 
;;      例えば「abracadabra」という入力では、<s>=「abra」が最長なので
;;      <s> <t>=「cadabra」の予測が優先されます。
;;
;; ● 設定方法
;;
;;  .emacsなどに以下の行を入れて下さい。
;;
(defconst *dmacro-key* "\C-t" "繰返し指定キー")
(global-set-key *dmacro-key* 'dmacro-exec)
(autoload 'dmacro-exec "dmacro" nil t)
;;
;; 増井俊之
;; シャープ株式会社 ソフトウェア研究所
;; masui@shpcsl.sharp.co.jp
;;

(defvar *dmacro-str* nil "繰返し文字列")
(setq dmacro-keys (concat *dmacro-key* *dmacro-key*))

(defun dmacro-exec ()
  "キー操作の繰返しを検出し実行する"
  (interactive)
  (let ((s (dmacro-get)))
    (if (null s)
	(message "操作の繰返しが見つかりません")
      (execute-kbd-macro s)
      )
    ))

(defun dmacro-event (e)
  (cond
   ((integerp e) e)
   ((eq e 'backspace) 8)
   ((eq e 'tab) 9)
   ((eq e 'enter) 13)
   ((eq e 'return) 13)
   ((eq e 'escape) 27)
   ((eq e 'delete) 127)
   (t 0)
   ))

(defun dmacro-recent-keys ()
  (let ((s (recent-keys)) )
    (if (stringp s) s
      (concat (mapcar 'dmacro-event s))
      )
    ))

(defun dmacro-get ()
  (let ((rkeys (dmacro-recent-keys)) str)
    (if (string= dmacro-keys (substring rkeys (- (length dmacro-keys))))
        *dmacro-str*
      (setq str (dmacro-search (substring rkeys 0 (- (length *dmacro-key*)))))
      (if (null str)
          (setq *dmacro-str* nil)
        (let ((s1 (car str)) (s2 (cdr str)))
          (setq *dmacro-str* (concat s2 s1))
          (setq last-kbd-macro *dmacro-str*)
          (if (string= s1 "") *dmacro-str* s1)
          )))))

(defun dmacro-search (string)
  (let* ((str (string-reverse string))
         (sptr  1)
         (dptr0 (string-search (substring str 0 sptr) str sptr))
         (dptr dptr0)
         maxptr)
    (while (and dptr0
                (not (string-search *dmacro-key* (substring str sptr dptr0))))
      (if (= dptr0 sptr)
          (setq maxptr sptr))
      (setq sptr (1+ sptr))
      (setq dptr dptr0)
      (setq dptr0 (string-search (substring str 0 sptr) str sptr))
      )
    (if (null maxptr)
        (let ((predict-str (string-reverse (substring str (1- sptr) dptr))))
          (if (string-search *dmacro-key* predict-str)
              nil
            (cons predict-str (string-reverse (substring str 0 (1- sptr)))))
          )
      (cons "" (string-reverse (substring str 0 maxptr)))
      )
    ))

(defun string-reverse (str)
  (concat "" (reverse (mapcar (function (lambda (x) x)) str))))

(defun string-search (pat str &optional start)
  (let* ((len (length pat))
	 (max (- (length str) len))
	 p found
	 )
    (setq p (if start start 0))
    (while (and (not found) (<= p max))
      (setq found (string= pat (substring str p (+ p len))))
      (if (not found) (setq p (1+ p)))
      )
    (if found p nil)
    ))
