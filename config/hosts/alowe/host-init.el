(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe/host-init.el,v 1.27 2004-12-22 23:56:07 cvs Exp $")

(setq default-fontspec
      (default-font 
	(setq default-font-family "tahoma")
	(setq default-style "normal")
	(setq default-point-size 16))
      )

(setq initial-frame-alist
      `((top . 40)
 	(left . 0)
 	(width . 142)
 	(height . 30)
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
	(font . ,default-fontspec)
	(menu-bar-lines . 0))
      )

(setq default-frame-alist  initial-frame-alist)

; tweak load-path to use working versions if found. will this stuff ever stabilize?
(loop for e in '(
		 ("site-lisp/tw-3.01" "/x/tw/site-lisp")
		 ("site-lisp/db-1.0" "/x/db/site-lisp")
		 ("site-lisp/xz-3.1" "/x/xz/site-lisp")
		 ("site-lisp/tx-1.0" "/x/elisp")
		 )
      when (file-directory-p (cadr e))
      do 
      (setq load-path
  ; first remove published versions, if any
	    (nconc (remove-if '(lambda (x) (string-match (car e) x)) load-path)
  ; then add working versions
		   (cdr e))
	    )
      )


(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

(defvar *people-database* '("~/n/people") "list of contact files")

(display-time)

(require 'trim)
(require 'sh)

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

(add-hook 'xdb-init-hook
	  '(lambda ()
	     (require 'ctl-slash)
	     (define-key ctl-/-map "x" 'xdb)

	     (if (evilnat)
		 (setq *txdb-options* '("-b" "a/q-1pzl@x" "-h" "enoch:3306"))
	       (setq *txdb-options* '("-b" "a/q-1pzl@x" "-h" "localhost:13306"))
	       )
	     )
	  )

(setq *advise-help-mode-finish* t)

(setq xosust-file "/usr/share/specs/xosus3.htm")

