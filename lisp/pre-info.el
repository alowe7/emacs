(put 'pre-info 'rcsid
 "$Id: pre-info.el,v 1.1 2001-07-18 22:18:18 cvs Exp $")

(require 'advice)

(defadvice info (before 
		 hook-info
		 first 
		 activate)
  (cd "/")
  )
