(put 'pre-xz-loads 'rcsid 
 "$Id$")

(add-hook 'xz-load-hook 
	  '(lambda () 
	     (xz-squish 4)
	     (setq *xz-lastdb* "~/emacs/.xz.dat")
	     (setq *xz-show-status* nil)
	     )
	  )
