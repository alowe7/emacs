(put 'host-init 'rcsid 
 "$Id: host-init.el,v 1.3 2000-11-20 01:56:42 cvs Exp $")

(default-font "lucida console" nil 22)

(set-frame-size (selected-frame) 72 30)
(set-frame-position (selected-frame) 10 10)

(add-to-list 'Info-default-directory-list "/usr/local/lib/gnuwin-1.0/usr/info")
(add-to-list 'Info-default-directory-list "/usr/local/lib/gnuwin-1.0/contrib/info")

(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )


(display-time)
