(put 'post-people 'rcsid 
 "$Id: post-people.el,v 1.5 2003-08-29 16:50:28 cvs Exp $")

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (let ((f (string* `*people-database* 
		    (progn (message "%d elements in list" (length *people-database*))
			   (sleep-for 1)
			   (roll-list *people-database*)
			   )
		    )
	   ))
    (find-file f)
    )
  )


(setq *minibuffer-display-unique-hit* t)
