(defconst rcs-id "$Id: post-people.el,v 1.1 2000-08-07 15:59:32 cvs Exp $")

(defun vn ()
  " suck people file into an edit buffer"
  (interactive)
  (find-file *people-database*)
  )
