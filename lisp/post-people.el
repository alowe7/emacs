(put 'post-people 'rcsid 
 "$Id: post-people.el,v 1.3 2000-10-03 16:50:28 cvs Exp $")

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (find-file *people-database*)
  )
