(put 'outliers 'rcsid 
 "$Id: outliers.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")
; a few more outliers
(mapcar '(lambda (x) (load x t t)) 
	'(
  ;	  "post-debug.el"
	  "post-etags.el"))
