(put 'filetime 'rcsid 
 "$Id: filetime.el,v 1.3 2000-10-03 16:50:27 cvs Exp $")


(defun filemodtime (f)
  (elt (file-attributes f) 5))
(defun fileacctime (f)
  (elt (file-attributes f) 4))

(defun compare-filetime (a b)
  "compare file times A and B.
 returns -1 if A preceeds B, 0 if they're equal, 1 otherwise "
  (cond ((null (or a b)) 0)
	((null a) -1)
	((null b) 1)
	((< (car a) (car b)) -1)
	((> (car a) (car b)) 1)
	((< (cadr a) (cadr b)) -1)
	((> (cadr a) (cadr b)) 1)
	(t 0)))

