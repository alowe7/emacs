(put 'post-people 'rcsid "$Id: post-people.el,v 1.2 2000-10-03 16:44:07 cvs Exp $")

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (find-file *people-database*)
  )
