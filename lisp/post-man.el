(put 'post-man 'rcsid "$Id: post-man.el,v 1.2 2000-10-03 16:44:07 cvs Exp $")

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))
