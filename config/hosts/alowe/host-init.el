(put 'host-init 'rcsid 
 "$Id: host-init.el,v 1.4 2000-11-20 02:36:16 cvs Exp $")

(default-font "lucida console" nil 22)

(set-frame-size (selected-frame) 72 30)
(set-frame-position (selected-frame) 10 10)

(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )

(display-time)
