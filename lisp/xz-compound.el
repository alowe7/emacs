(put 'xz-compound 'rcsid
 "$Id$")

(defvar *default-proximity-limit* 5)
(defvar *proximity-limit* *default-proximity-limit*) 

(defun xz-compound-query (q1 q2 &optional constraint limit)
  "perform a compound query, joining on QUERY1 and QUERY2.
see `xz-query-format`
"
  (interactive "scompound query1: \nsquery2: ")
  (xz-query-format
   (let ((l1 (xz-issue-query q1 constraint))
	 (l2 (xz-issue-query q2 constraint)))
     (loop for x in l1 
	   when 
	   (loop for y in l2 thereis 
; find elements of q2 such that they are within *proximity-limit* of a hit in q1

		 (and (string= (cadr x) (cadr y)) 
		      (<= (abs (- (caddr x) (caddr y))) (or limit *proximity-limit*)))
		 )
	   collect x ))
   )
  )

; this finds hits within adjacent lines
; (xz-compound-query ".fDetach"  ".fRelease" 1)

; this finds hits on the same line
; (xz-compound-query "CFDLib" "Release" 0)


(defun xz-query-predicate (q1 q2 pred)
  "join two queries by matching arbitrary predicates"
  (interactive "sq1: \nsq2: ")

  ; find elements of q1, q2 such that they satisfy predicate

  (xz-query-format
   (let ((l1 (xz-issue-query q1))
	 (l2 (xz-issue-query q2)))
     (loop for x in l1
	   when 
	   (loop for y in l2 thereis (funcall pred x y))
	   collect x )
     )
   )
  )

; this finds hits on the same line -- equivalent to above
; (xz-query-predicate ".fDetach" ".fRelease" '(lambda (x y) (and (string= (cadr x) (cadr y)) (= (caddr x) (caddr y)))))
; (xz-query-predicate "CreateInstance" "Release" '(lambda (x y) (and (string= (cadr x) (cadr y)) (<= (abs (- (caddr x) (caddr y))) 50))))


(defun xz-stats ()
	(xz-do-stats (v (xz-issue-query (format ".M%s" (or pat ""))))))


(defun xz-do-stats (v)
  (let ((b (zap-buffer "*stats*"))
	(d (/ (length v) 10)))
    (loop for x in v
	  with i = 0
	  do
	  (let ((l (xz-issue-query (format "./ml%s" (car x))))
		(s (xz-issue-query (format "./ms%s" (car x)))))
	    (set-buffer b)
	    (condition-case err
		(insert 
		 (format "%s\t%d\t%d\n" (car x) 
			 (or (caddr (car l)) 0)
			 (or (caddr (car s)) 0)))
	      (error nil)
	      )
	    (setq i (1+ i))
	    (if (= 0 (% i d)) (message "."))
	    )
	  )
    (pop-to-buffer "*stats*")
    )
  )

; (xz-stats)
; (xz-stats "ComponentLibs")
; (xz-stats "Announcement")


(defun xzq (query)
"quick and dirty xz query. no formatting"
  (save-excursion
    (set-buffer (xz-buffer))
    (erase-buffer)
    (send-string (xz-process) (concat query "\n"))
    (xz-wait)
    (buffer-string)
    )
  )

(defun safe-xzq (query)
  "save regexp and prompting state; reset them; apply `xzq` on QUERY; and restore state
QUERY may be a string or a list of strings
"
  (let ((regexp (string= (substring (xzq ".*?") 0 1) "1"))
	(quiet (string= (substring (xzq "!?") 0 1) "1"))
	ret)
    (xzq ".*+")
    (xzq "!+")
    (setq ret 
	  (if (listp query)
	      (loop for x in query collect (read (xzq x)))
	    (read (xzq query)))
	  )
    (xzq (if regexp ".*+" ".*-"))
    (xzq (if quiet "!+" "!-"))
    ret
    )
  )

; (let ((pat "Announcement")) (safe-xzq (format "./ms%s" pat)))

(defun xz-stats2 (pat)
  (let* ((pat (or pat ""))
	 (bn "*stats*")
	 (b (zap-buffer bn))
	 (q (safe-xzq (list (format "./ml%s" pat) (format "./ms%s" pat))))
	 (d (/ (length v) 10))
	 (l (car q))
	 (s (cadr q))
	 (v (loop for x in l
		  collect
		  (list (car x) (cadr x) (caddr (assoc (car x) s)) (caddr x))))
	 (i 0))

    (set-buffer b)

    (loop for x in v 
	  do
	  (insert 
	   (format "%s\t%d\t%d\n" 
		   (nth 0 x) 
		   (or (nth 2 x)  0)
		   (or (nth 3 x) 0)))
	  (setq i (1+ i))
	  (if (= 0 (% i d)) (message "."))
	  )
    (pop-to-buffer "*stats*")
    )
  )

; (xz-stats2 "ComponentLibs")


(defun xz-constrained-compound-query (q1 q2 constraint &optional limit)
  (interactive "sconstrained compound query1: \nsquery2: \nsconstraint: ")
  (xz-compound-query q1 q2 constraint limit)
  )

;  (xz-constrained-compound-query "SRCManager" "CreateInstance" "VTBlade")

(defun set-proximity-limit (arg)
  (interactive "p")
  (setq *proximity-limit* (or arg *default-proximity-limit*))
  (message "*proximity-limit* set to %d" *proximity-limit*)
  )

