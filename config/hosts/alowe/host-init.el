(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe/host-init.el,v 1.6 2001-02-27 12:46:03 cvs Exp $")

;(default-font "lucida console" nil 22)

;(set-frame-size (selected-frame) 72 30)
;(set-frame-position (selected-frame) 10 10)

(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )

(display-time)

(require 'xz-loads)

