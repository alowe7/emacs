(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.21 2002-02-27 21:22:17 cvs Exp $")

(setq default-frame-alist
      '((top + -4)
	(left + -4)
	(width . 128)
	(height . 55)
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

; 
;     
;   )
; 
(loop for x in '("/x/elisp")
      do 
      (if (file-directory-p x)
	  (let ((xloads (format "%s/.loads" x)))
	    (cond ((file-exists-p xloads)
		   (progn
		     (add-to-list 'load-path x)
		     (load-file xloads)
		     ))
		  ((file-exists-p (setq xloads (format "%s/.autoloads" x)))
		   (load xloads t t t)))
	    )
	)
      )

(setq *key-program* "d:/a/bin/key.exe")

(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))



;(get-directory-files d t "\.el$")

(add-hook 'after-init-hook '(lambda () 
			      (defadvice info (before 
					       hook-info
					       first 
					       activate)
				(cd "/")
				)))

(add-hook 'people-load-hook (lambda () ; (require 'worlds)
			      (setq *people-database*
				    (list (xwf "n/people.csv" "broadjump")
					  "~/n/people"))))

(setq *shell-track-worlds* t)

(display-time)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(require 'gnuserv)

(setenv "XDBHOST" "kim.alowe.com")
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(require 'worlds)
(require 'world-advice)

(lastworld)

(mount-hook-file-commands)

;; hack process environment to minimal path so that man will work as expected
(scan-file (concat "~/.bashrc." (hostname)))
(w32-canonify-env "PATH")
(w32-canonify-env "HOME")
(w32-canonify-env "CLASSPATH")

(setq *howto-path* (nconc 
		    (list "d:/d/offering/n/howto" "z:/b/core/test/howto" "z:/b/vta/howto" "z:/b/vta/n")
		    (split ($ "$HOWTOPATH") ":")))

(if nil
    (setq *howto-alist* 
	  (loop
	   for x in *howto-path*
	   with l = nil
	   nconc (loop for y in (get-directory-files x)
		       collect (list y x)) into l
	   finally return l))
  )