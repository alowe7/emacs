(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.3 2000-10-03 16:50:28 cvs Exp $")

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))
