(put 'qc 'rcsid
 "$Id: qc.el,v 1.1 2008-07-02 01:44:09 alowe Exp $")

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

;;; xxx police line do not cross
(defun datestamp (&optional spec)
  "spec can be a mixed argument like -1d meaning yesterday or +1h meaning one hour from now"
  (interactive)

  (let ((spec (or spec "0"))
	(sec (eval-process "date" "+%s"))
	(factor 1) (nsec 1) (deltasec 0) otherdate)

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

    (setq delta (read spec))

;; stupid lisp arithmetic cant handle this calculation
;   (setq sec (+ (read sec) (* factor delta)))
 
    (setq sec (qc (format "%s + (%d * %d)" sec factor delta)))

    (setq otherdate (mktime sec t))

  ; assert spec is a string representation of a valid integer
    (let ((v 
	   (kill-new (eval-process "date" "+%y%m%d%H%M%S" (format "--date=%s" otherdate)))))
      (if (interactive-p) (message v))
      v)
    )
  )
; produce a datestamp for yesterday
; (datestamp "-1d")
; three days ago
; (datestamp "-3d")
; three hours ago
; (datestamp "-3h")
; now
; (datestamp)
