(put 'post-lisp 'rcsid
 "$Id: post-lisp.el,v 1.2 2007-04-03 19:17:35 alowe Exp $")

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
