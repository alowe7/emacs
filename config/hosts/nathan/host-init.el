(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/nathan/host-init.el,v 1.2 2003-05-17 18:18:32 cvs Exp $")

(setq default-frame-alist
      '((top + -4)
	(left + -4)
	(width . 102)
	(height . 42)
	(background-mode . light)
	(cursor-type . box)
	(border-color . "black")
	(cursor-color . "black")
	(mouse-color . "black")
	(background-color . "white")
	(foreground-color . "black")
	(vertical-scroll-bars)
	(internal-border-width . 0)
	(border-width . 2)
	(font . "-*-lucida console-normal-r-*-*-17-nil-*-*-*-*-*-*-")
	(menu-bar-lines . 0))
      )

(setq initial-frame-alist default-frame-alist)

(setq *people-database*  '("/a/n/people"))

(defvar mandirs (catlist (getenv "MANPATH") ?;))

; xz-squish is currently global.  todo: make per process
(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   (load-library "xz-helpers")
			   )
	  )

(display-time)
; (requirex 'worlds)
(defun evilnat () (not (string-match "ok" (perl-command "evilnat"))))

(require 'xz-loads)
(require 'gnuserv)

;(load-library "xdb")
(scan-file-p "~/.xdbrc")

(setq Info-default-directory-list '("/usr/share/emacs/info/"))

