(put 'post-compare-w 'rcsid 
 "$Id$")

(defun compare-windows-2 (&optional whitespace)
  (interactive)
  (if whitespace 
      (compare-windows)
    (let ((pat "[ 	
]+"))
      (while
	  (progn
	    (compare-windows)
	    (if (looking-at pat) 
		(re-search-forward pat nil t)
	      (progn
		(other-window 1)
		(if (looking-at pat)
		    (re-search-forward pat nil t)
		  nil))
	      )
	    )
	)
      )
    )
  )
