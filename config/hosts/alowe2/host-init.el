(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.2 2001-05-18 12:15:34 cvs Exp $")

;(default-font "lucida console" nil 22)

;(set-frame-size (selected-frame) 72 30)
;(set-frame-position (selected-frame) 10 10)

(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 5)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )

(display-time)

;; (require 'worlds)

;; (require 'xz-loads)

;; (global-set-key "n" 'x-note)

(require 'gnuserv)
(gnuserv-start)
