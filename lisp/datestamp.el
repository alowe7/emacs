(put 'datestamp 'rcsid
 "$Id: datestamp.el,v 1.1 2006-08-08 14:20:13 alowe Exp $")

;;; xxx police line do not cross
;; fancy
(defun qc (expr)
  "perform a quick calculation of expression like '100 + 1000' or 'x  + y' assuming both are bound
evaluation of variables is done like that in `backquote`
supports big ints"
  (let* (
	 (l (loop for a in (split expr)
		  collect
		  (let ((s (intern a)))
		    (if (boundp s)
			(let ((v (eval s)))
			  (cond ((stringp v) v)
				((integerp v) (format "%d" v))))
		      a)
		    )
		  ))
	 (sexpr (mapconcat 'identity l " ")))
    (eval-process "perl" "-e" (concat "print " sexpr))
    )
  )

; (let* ((x 100) (y 1000)) (qc "x + y"))


(defun datestamp (&optional spec)
  "optional string SPEC can be a mixed argument like -1d meaning yesterday or +1h meaning one hour from now, or the string 'now'"

  (interactive)

  (let ((sec (eval-process "date" "+%s"))
	(factor 1) (nsec 1) 
	(deltasec 0)
	(spec (cond ((and (string* spec) (string= spec "now")) nil) (t spec)))
	otherdate)

    (unless (not spec)
	
	(cond ((string-match "h$" spec)
	       (setq factor (* 60 60))
	       (setq spec (substring spec 0 (match-beginning 0))))
	      ((string-match "m$" spec)
	       (setq factor 60)
	       (setq spec (substring spec 0 (match-beginning 0))))
	      ((string-match "s$" spec)
	       (setq factor 1)
	       (setq spec (substring spec 0 (match-beginning 0))))
	      ((string-match "d$" spec)
	       (setq factor (* 60 60 24))
	       (setq spec (substring spec 0 (match-beginning 0))))
	      ((string-match "w$" spec)
	       (setq factor (* 7 60 60 24))
	       (setq spec (substring spec 0 (match-beginning 0))))
	      (t ;; default is secs
	       (setq factor 1)
	       ))

      (cond ((string-match "^+$" spec)
	     (setq spec (substring spec (match-end 0))))
	    ((string-match "^-$" spec)
	     (setq factor (- factor))
	     (setq spec (substring spec (match-end 0))))
	    )

      (setq deltasec (read spec))
      )

;; stupid lisp arithmetic cant handle this calculation
;   (setq sec (+ (read sec) (* factor delta)))
 
    (setq sec (qc (format "%s + (%d * %d)" sec factor deltasec)))

    (setq otherdate (mktime sec t))

  ; assert spec is a string representation of a valid integer

    (eval-process "date" "+%y%m%d%H%M%S" (format "--date=%s" otherdate))
    )
  )
; produce a datestamp for yesterday
; (datestamp "-1d")
; (string= (datestamp "now") (datestamp))
; (string= (datestamp "0") (datestamp))
; (datestamp "-3d")
; (datestamp "-3h")

