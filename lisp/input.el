(defconst rcs-id "$Id: input.el,v 1.1 2000-08-07 15:59:31 cvs Exp $")

(defun y-or-n-*-p (prompt &optional chars &rest args)
  "display PROMPT and read characters.
returns t for y, nil for n ?q for q, else loop
with optional string CHARS, also matches specified characters.
"
  (interactive)
  (catch 'done
    (while t
      (apply 'message (cons prompt args))
      (let ((c (read-char)) x)
	(cond 
	 ((char-equal c ?y) (throw 'done t))
	 ((char-equal c ?n) (throw 'done nil))
	 (chars
	  (dotimes (x (length chars)) 
	    (let ((c2 (aref chars x))) 
	      (and (char-equal c c2) (throw 'done c2)))))
	 (t (setq prompt (format "%s (y %s to continue, n for next): " prompt 
				 (string* chars "")
				 )))
	 )
	)
      )
    )
  )

(defun y-or-n-q-p (prompt &optional chars &rest args)
  "display PROMPT and read characters.
returns t for y, nil for n ?q for q, else loop
with optional string CHARS, also matches specified characters.
"
  (interactive)
  (catch 'done
    (while t
      (apply 'message (cons prompt args))
      (let ((c (read-char)) x)
	(cond 
	 ((char-equal c ?q) (throw 'done ?q))
	 ((char-equal c ?y) (throw 'done t))
	 ((char-equal c ?n) (throw 'done nil))
	 (chars
	  (dotimes (x (length chars)) 
	    (let ((c2 (aref chars x))) 
	      (and (char-equal c c2) (throw 'done c2)))))
	 (t (setq prompt (format "%s (y to continue, n for next, q to quit loop): " prompt)))
	 )
	)
      )
    )
  )
