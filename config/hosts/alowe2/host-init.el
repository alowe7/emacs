(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.22 2002-03-14 17:51:40 cvs Exp $")

(setq default-frame-alist
      '((width . 102)
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

(add-hook 'people-load-hook (lambda () ; (require 'worlds)
			      (setq *people-database*
				    (list (xwf "n/people.csv" "broadjump")
					  "~/n/people"))))
(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

(add-hook 'after-init-hook '(lambda () 
			      (defadvice info (before 
					       hook-info
					       first 
					       activate)
				(cd "/")
				)))

(defvar *howto-path* (nconc 
		    (list "d:/d/offering/n/howto" "z:/b/core/test/howto" "z:/b/vta/howto" "z:/b/vta/n")
		    (split ($ "$HOWTOPATH") ":")))

(defvar *howto-alist* 
  (if nil (loop
	   for x in *howto-path*
	   with l = nil
	   nconc (loop for y in (get-directory-files x)
		       collect (list y x)) into l
	   finally return l))
  )

(require 'worlds)
(require 'world-advice)
(setq *shell-track-worlds* t)

(scan-file "~/.xdbrc")

; (setenv "XDBHOST" "kim.alowe.com")
; (setenv "XDB" "x")
; (setenv "XDBUSER" "a")

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)


(require 'gnuserv)
(display-time)

