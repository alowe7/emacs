(put 'post-man 'rcsid 
 "$Id: post-man.el,v 1.5 2004-03-17 16:20:43 cvs Exp $")

(require 'advice)

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))
