(put 'post-other 'rcsid
 "$Id$")

(defadvice rfo (around 
			   hook-rfo
			   first activate)
  ""

(let ((p (point)))
  ad-do-it
  (goto-char (min p (point-max))))
)
