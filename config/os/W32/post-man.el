(put 'post-man 'rcsid 
 "$Id$")

(require 'advice)

(defun fix-man-page ()
  (interactive)
  (save-excursion
    (kill-pattern "_") ; hack for roff underlining
    (kill-pattern ".")
    (kill-pattern "8")
    (kill-pattern "9")
    ))
