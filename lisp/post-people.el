(put 'post-people 'rcsid 
 "$Id: post-people.el,v 1.4 2001-09-07 21:36:42 cvs Exp $")

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (find-file *people-database*)
  )

(setq *minibuffer-display-unique-hit* t)
