(put 'mktime 'rcsid
 "$Id: mktime.el,v 1.1 2006-05-19 14:48:36 tombstone Exp $")

; some date and timestamp utilities

; see thingatpt
(put 'date 'thing-at-point 'date-at-point)
(defvar partial-date-regexp "\\(Mon\\|Tue\\|Wed\\|Thu\\|Fri\\|Sat\\|Sun\\)* *\\(Jan\\|Feb\\|Mar\\|Apr\\|May\\|Jun\\|Jul\\|Aug\\|Sep\\|Oct\\|Nov\\|Dec\\)* *\\([0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]\\)* *\\([0-9][0-9][0-9][0-9]\\)")
(defvar date-regexp "\\(Mon\\|Tue\\|Wed\\|Thu\\|Fri\\|Sat\\|Sun\\) \\(Jan\\|Feb\\|Mar\\|Apr\\|May\\|Jun\\|Jul\\|Aug\\|Sep\\|Oct\\|Nov\\|Dec\\) \\([0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]\\) \\([0-9][0-9][0-9][0-9]\\)")
(defun date-at-point (&optional parts)
  "return date expression under point.
  from a program with optional argument PARTS, returns a date broken out into a list as: (dow mon day time year)"
  (interactive)

  (save-excursion
    (if
	(or (looking-at date-regexp)
	    (progn 
	      (re-search-forward partial-date-regexp nil t)
	      (re-search-backward date-regexp nil t)
	      ))

	(if parts
	    (loop for i from 1 to 4 collect (buffer-substring (match-beginning i) (match-end i)))
	  (buffer-substring (match-beginning 0) (match-end 0)))
      )
    )
  )

(defun mktimestamp (arg)
  (interactive "P")
  (let* ((args '("date" "+%s")) 
	 (displayfn (if (interactive-p) 'message 'identity)) )
    (if arg
	(nconc args (list (format"--date=%s" (thing-at-point 'date)))))

    (funcall displayfn
	     (kill-new (apply 'eval-process args)))
    )
  )

(defun mktime (&optional sec reverse)
  (interactive (list (read-string* "tm (%s) " (thing-at-point 'word))))
  (let ((v
	 (chomp (chomp 
		 (cond ((and sec reverse)
			(apply 'eval-process (list "mktime" "-v" sec)))
		       (sec
			(apply 'eval-process (list "mktime" sec)))
		       (t
			(apply 'eval-process (list "mktime")))
		       )))))
    (if (interactive-p) (message v) v)
    )
  )

; (mktime "1141230058" t)
; (mktime "1141230058")
; (mktime)

(provide 'mktime)
