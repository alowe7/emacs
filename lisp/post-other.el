(put 'post-other 'rcsid
 "$Id: post-other.el,v 1.1 2002-09-23 01:58:37 cvs Exp $")

(defadvice rfo (around 
			   hook-rfo
			   first activate)
  ""

(let ((p (point)))
  ad-do-it
  (goto-char (min p (point-max))))
)
