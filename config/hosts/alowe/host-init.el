(put 'host-init 'rcsid 
 "$Id: host-init.el,v 1.2 2000-11-20 01:03:02 cvs Exp $")

; (setenv "PATH" "/bin:/Perl/bin/:/WINNT/system32:/WINNT:/WINNT/System32/Wbem:/a/bin:/Perl/bin/:/WINNT/system32:/WINNT:/WINNT/System32/Wbem:/PROGRA~1/Tcl/bin:/usr/local/lib/emacs-20.5/bin:/usr/local/lib/gnuwin-1.0/bin:/usr/local/lib/gnuwin-1.0/contrib/bin:/usr/local/bin")

(add-to-list 'Info-default-directory-list "/usr/local/lib/gnuwin-1.0/usr/info")
(add-to-list 'Info-default-directory-list "/usr/local/lib/gnuwin-1.0/contrib/info")

(message "welcome to broadjump!")

(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )


(set-frame-size (selected-frame) 80 35)
(set-frame-position (selected-frame) 10 10)

(display-time)
