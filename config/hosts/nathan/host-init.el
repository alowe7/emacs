(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/nathan/host-init.el,v 1.6 2004-04-04 16:23:48 cvs Exp $")

(setq default-frame-alist
      '((top + 80)
	(left + 80)
	(width . 80)
	(height . 28)
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

; use working versions. will this stuff ever stabilize?
(let ((r '(
	   ("site-lisp/tw-3.01" "/x/tw/site-lisp")
	   ("site-lisp/db-1.0" "/x/db/site-lisp")
	   ("site-lisp/xz-3.1" "/x/xz/site-lisp")
	   ("site-lisp/tx-1.0" "/x/elisp")
	   ))
      )
  (loop for e in r do 
	(setq load-path
  ; first remove published versions, if any
	      (nconc (remove-if '(lambda (x) 
				   (string-match (car e) x)) load-path)
  ; then add working versions
		     (cdr e))
	      )
	)
  )

(let ((dir "D:/usr/local/lib/emacs-21.3/bin"))
(and (y-or-n-p (format "set exec dir (%s) to %s?" exec-directory dir))
     (setq exec-directory	dir)))

(if (string-match "21" emacs-version)
    (fonty "tahoma"))

