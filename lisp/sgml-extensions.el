(put 'sgml-extensions 'rcsid 
 "$Id$")

;; some sgml extensions
(setq html-mode-keys '(("" new-para)
				  ("" break)
				  ("b" toggle-bold)
				  ("i" toggle-italic)
				  ("c" toggle-center)
				  ("" toggle-pre)
				  (";" toggle-comment)
				  ("t" toggle-table)
				  ("" toggle-caption)
				  ("r" toggle-row)
				  ("c" toggle-column)
				  ("" open-column)
				  ("f" next-column) ("b" prev-column)
				  ("\"" insert-quote)
				  ("<" insert-langle)
				  (">" insert-rangle)
				  ("" html-mode-help)
				  ; ((vector 3 67108910) insert-dt) ; C-c C-. believe it or not
				  ))


(defun html-mode-help () (interactive)
  (let ((b "*Help*"))
    (zap-buffer b)
    (dolist (x html-mode-keys)
      (insert (format "%s	%s\n" (car x) (cadr x))))
    (pop-to-buffer b)
    (goto-char (point-min))
    )
  )


(setq html-mode-hook (function (lambda () 
  ; binds funky local keys
			(mapc (function (lambda (x) (local-set-key (car x) (cadr x))))
				html-mode-keys 
				)
			(setq paragraph-start "[ 	
]\\|\\(</?\\([A-Za-z]\\([-.A-Za-z0-9= 	
]\\|\"[^\"]*\"\\|'[^']*'\\)*\\)?>\\)")
			)))


(defun insert-quote () (interactive)
(insert "&quot;"))
(defun insert-langle () (interactive)
(insert "&lt;"))
(defun insert-rangle () (interactive)
(insert "&gt;"))

(defun new-para () (interactive)
(insert "<P>\n"))

(defun break () (interactive)
(insert "<BR>\n")
)


(defvar is-table nil)


(defvar is-center nil)
(defun toggle-center () (interactive)
  (if (not is-center)
      (progn (insert "<CENTER>") (setq is-center t))
    (progn (insert "</CENTER>") (setq is-center nil))))

(defvar is-comment nil)
(defun toggle-comment () (interactive)
  (if (not is-comment)
      (progn (insert "<!-- ") (setq is-comment t))
    (progn (insert " --!>") (setq is-comment nil))))

(defvar is-bold nil)
(defun toggle-bold () (interactive)
; open bold-formatted section
(if (not is-bold)
      (progn (insert "<B>") (setq is-bold t))
    (progn (insert "</B>") (setq is-bold nil))))

(defvar is-italic nil)
(defun toggle-italic () (interactive)
; open italic-formatted section
(if (not is-italic)
      (progn (insert "<I>") (setq is-italic t))
    (progn (insert "</I>") (setq is-italic nil))))

(defvar is-pre nil)
(defun toggle-pre () (interactive)
; open pre-formatted section
(if (not is-pre)
      (progn (insert "<PRE>") (setq is-pre t))
    (progn (insert "</PRE>") (setq is-pre nil))))

(defun toggle-table (&optional border) (interactive)
  (if (not is-table)
      (progn (insert (format "<TABLE BORDER=%s>\n" (if border 1 0))) (setq is-table t))
    (progn (insert "</TABLE>\n") (setq is-table nil))))

(defvar is-caption nil)
(defun toggle-caption () (interactive)
(if (not is-caption )
    (progn (insert "<CAPTION align=bottom><CENTER><B>") (setq is-caption t))
(progn (insert "</B></CENTER></CAPTION>") (setq is-caption nil))))

(defvar is-row nil)
(defun toggle-row () (interactive)
  (if is-row
      (insert "</TD></TR>")
    (insert "<TR><TD>"))
  (setq is-row (not is-row))
)

(defvar is-column  nil)
(defun toggle-column () (interactive)
					; inserts column break
  (if is-column
      (insert "</TD>")
    (insert "</TD><TD>")
    )
  (setq is-column (not is-column))
  )

(defun open-column () (interactive)
					; inserts column break
    (insert "</TD><TD>")
  )

(defun next-column () (interactive)
; moves to next column in table
(search-forward "</TD><TD>"))

(defun prev-column () (interactive)
; moves to prev column in table
(search-backward "</TD><TD>"))

(defun insert-dt () (interactive)
(insert "<dt>"))


(require 'indicate)
(require 'fapropos)

(add-hook 'html-mode-hook (function (lambda ()
			     (define-key html-mode-map "?" 'find-w32-fn)
			     (global-set-key "?" 'find-w32-fn)
			     (define-key html-mode-map "" 'fapropos)
			     (define-key html-mode-map "" 'find-win32-sig)
			     )))


(defalias 'fix-angles (read-kbd-macro
"ESC C-s		
^#include[	
SPC		
TAB		
]*<		
RET		
DEL		
&lt;		
ESC C-s		
>$		
RET		
DEL		
&gt;		
"))

(setq sgml-specials '(?\" ))
