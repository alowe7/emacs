(put 'pre-xz-loads 'rcsid 
 "$Id: pre-xz-loads.el,v 1.1 2001-07-18 22:18:18 cvs Exp $")

(add-hook 'xz-load-hook 
	  '(lambda () 
	     (xz-squish 4)
	     (setq *xz-lastdb* "~/emacs/.xz.dat")
	     (setq *xz-show-status* nil)
	     )
	  )
