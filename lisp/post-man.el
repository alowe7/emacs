(defconst rcs-id "$Id: post-man.el,v 1.1 2000-08-07 15:59:32 cvs Exp $")

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))
