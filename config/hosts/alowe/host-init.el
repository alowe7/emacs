(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe/host-init.el,v 1.17 2002-06-19 13:49:02 cvs Exp $")

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
	(font . "-*-lucida console-normal-r-*-*-14-nil-*-*-*-*-*-*-")
	(menu-bar-lines . 0))
      )

(setq initial-frame-alist default-frame-alist)

(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

(defvar *people-database* '("~/n/people") "list of contact files")

(display-time)

; (require 'worlds)
; (require 'world-advice)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(scan-file-p "~/.xdbrc")

(if (and (not (evilnat)) 
	 (string* (getenv "XDBHOST"))
	 (string* (getenv "XDBDOMAIN"))
	 (not (string-match (getenv "XDBDOMAIN") (getenv "XDBHOST"))))
    (setenv "XDBHOST" (concat (getenv "XDBHOST") "." (getenv "XDBDOMAIN"))))

(require 'gnuserv)

(mount-hook-file-commands)

(defvar grep-command "grep -n -i -e ")
