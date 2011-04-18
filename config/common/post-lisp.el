(put 'post-lisp 'rcsid
 "$Id$")

(defun unbind (thingname)
  (interactive (list (read-string* "make unbound (%s): " (thing-at-point (quote symbol)))))
  (let* ((thing (intern thingname))
	 (class (cond ((boundp thing) (makunbound thing) "symbol")
		      ((fboundp thing) (fmakunbound thing) "function"))))
    (and (interactive-p)
	 (message
	  (if class 
	      (format "%s %s unbound" class thingname)
	    (format "%s not bound" thingname)
	    )))
    )
  )
