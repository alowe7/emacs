(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.5 2001-07-17 11:14:19 cvs Exp $")

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

(require 'xz-loads)

;; (global-set-key "n" 'x-note)

(require 'gnuserv)
(gnuserv-start)
;; set default frame for gnuserving
(setq gnuserv-frame
      (caadr (current-frame-configuration)))

(lastworld)

(defvar *people-database* '("~/n/people") "list of contact files")

