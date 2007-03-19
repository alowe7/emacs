(put 'string-utils 'rcsid
 "$Id: string-utils.el,v 1.2 2007-03-19 17:37:13 alowe Exp $")

(defun string^ (s pat)
  "perform exclusive or of STRING with PAT."
  (if (string-match pat s)
      (replace-regexp-in-string pat "" s)
    (concat s pat))
  )

(defun string& (s pat)
  "append STRING by PAT, unless already there."
  (unless (string-match pat s)
    (concat s pat)
    s)
  )

;; xxx move to trim.el
(defun tr (str trmap)
  "replace chars in STRING according to alist MAP
where map is an alist of the form: ((char1 string1) (char2 string2))
"
  (let (prev)
    (apply 'concat (remove nil (loop for x across str 
				     collect
				     (prog1
					 (if (and 
					      (assoc x trmap) 
					      (not (and prev (char-equal prev ?\\ )))
					      )
					     (cadr (assoc x trmap))
					   (format "%c" x))
				       (setq prev x)
				       )
				     )
			   )
	   )
    )
  )
; (insert (tr "foo\\.bar" '((?* "%") (?. "_"))))


(provide 'string-utils)
