(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe/host-init.el,v 1.14 2002-02-27 21:18:05 cvs Exp $")

(setq default-frame-alist
      '((top + -4)
	(left + -4)
	(width . 102)
	(height . 44)
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

(defvar *people-database* '("~/n/people") "list of contact files")

(display-time)

; (require 'worlds)
; (require 'world-advice)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(defun evilnat () (not (string-match "ok" (perl-command "evilnat"))))

(setenv "XDBHOST" (if (evilnat) "kim" "kim.alowe.com"))
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(require 'gnuserv)

(mount-hook-file-commands)
