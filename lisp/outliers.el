(defconst rcs-id "$Id: outliers.el,v 1.3 2000-07-30 21:07:47 andy Exp $")
; a few more outliers
(mapcar '(lambda (x) (load x t t)) 
	'(
  ;	  "post-debug.el"
	  "post-etags.el"))
