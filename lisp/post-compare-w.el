(put 'post-compare-w 'rcsid 
 "$Id: post-compare-w.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")

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
