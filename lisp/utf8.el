"ÿþ"
(put 'utf8 'rcsid
 "$Id: utf8.el,v 1.1 2009/11/28 19:38:21 slate Exp $")

(setq *utf8-uglies* 
      '(
	("\205" "...")
	("\222" "'")  ; ’
	("\223" "\"") ; “
	("\224" "\"") ; ”
	("\226" "--") ; –
	(" " "a")  ; à
	(" " "e")  ; é
	)
      )

(defun fix-utf8-chars-in-string (s)
  (loop for x in *utf8-uglies* do (setq s (replace-regexp-in-string (car x) (cadr x) s)) finally return s)
  )

(defun fix-utf8-chars-in-buffer ()
  (interactive)
  (save-excursion
    (loop for x in  *utf8-uglies*
	  do
	  (goto-char (point-min))
	  (while (search-forward (car x) nil t)
	    (replace-match (cadr x) nil t))
	  )
    )
  )
(fset 'utf8-fix-file 'fix-utf8-chars-in-buffer)

(provide 'utf8)

