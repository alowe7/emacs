(put 'filetime 'rcsid 
 "$Id: filetime.el,v 1.4 2001-07-08 20:42:45 cvs Exp $")


(defun filemodtime (f)
  (and f (elt (file-attributes f) 5)))
(defun fileacctime (f)
  (and f (elt (file-attributes f) 4)))

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

(defun ftime () (interactive)
  "display formatted time string last modification time of file for current buffer"
  (let ((f (filemodtime (buffer-file-name))))
    (message (if f
		 (clean-string (eval-process "mktime" (format "%d" (car f)) (format "%d" (cadr f))))
	       "no file")
	     )
    )
  )
; (ftime)
