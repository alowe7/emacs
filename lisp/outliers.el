(put 'outliers 'rcsid "$Id: outliers.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
; a few more outliers
(mapcar '(lambda (x) (load x t t)) 
	'(
  ;	  "post-debug.el"
	  "post-etags.el"))
