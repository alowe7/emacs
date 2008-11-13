(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/keystone/host-init.el,v 1.14 2008-11-13 03:00:13 noah Exp $")

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq default-fontspec "-*-tahoma-normal-r-*-*-16-*-*-*-*-*-*-*-")

(setq initial-frame-alist
      `((top . 320)
 	(left . 400)
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

(setq default-frame-alist initial-frame-alist)
(add-association '(height . 20) 'default-frame-alist t)

(setq *people-database*  (expand-file-name (concat (getenv "HOME") "/n/people")))

; xz-squish is currently global.  todo: make per process
(add-hook 'xz-load-hook '(lambda () 
			   (xz-squish 2)
			   (setq *xz-lastdb* "~/emacs/.xz.dat")
			   )
	  )

(setq display-time-day-and-date t)
(display-time)

; (requirex 'worlds)

(require 'xz-loads)
; (when (not (and (boundp 'server-process) (process-live-p server-process))) (require 'gnuserv))

;(load-library "xdb")

; use working versions. will this stuff ever stabilize?
(let ((r '(
	   ("site-lisp/tw-3.01" "/x/tw/site-lisp")
	   ("site-lisp/db-1.0" "/x/db/site-lisp")
	   ("site-lisp/xz-3.1" "/x/xz/site-lisp")
	   ("site-lisp/tx-1.0" "/x/elisp")
	   ))
      )
  (loop for e in r 
	when
	(file-exists-p (cadr e))
	do 
	(setq load-path
  ; first remove published versions, if any
	      (nconc (remove-if '(lambda (x) 
				   (string-match (car e) x)) load-path)
  ; then add working versions
		     (cdr e))
	      )
	)
  )
; (setq load-path (remove-if '(lambda (x) (string-match "^/x" x)) load-path))

; man don't work with default path
; xxx (load-library "post-man")
(defvar mandirs (catlist (getenv "MANPATH") ?;))

; xxx (setq font-lock-support-mode 'lazy-lock-mode)
; xxx (add-hook 'perl-mode-hook (lambda () (lazy-lock-mode)))
; xxx (add-hook 'java-mode-hook (lambda () (lazy-lock-mode)))

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
	      (nconc (remove-if '(lambda (x) (string-match (car e) x)) load-path)
  ; then add working versions
		     (cdr e))
	      )
	)
  )

(add-to-load-path "/u/emacs-w3m-1.3.2")
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)

(add-to-load-path "/u/Mule-UCS-0.84/lisp/")

; all kinds of crap here
(add-to-load-path-p "/z/el" t)

; and some lisp here too
(add-to-load-path-p "/z/pl" t)

; gpg is here
(add-to-load-path-p "/z/gpg" t)

; defaults
(setq *gpg-command* "/usr/local/bin/gpg.exe")
;(setq *gpg-default-file*  "e:/home/alowe/.private/wink")
(setq *gpg-default-file*  "h:/wink")

; keyrings on removable compact flash card
;(setq *gpg-default-homedir*  "e:/home/alowe/.gnupg")
;(setq *gpg-default-homedir*  "h:/.gnupg")
(setq *gpg-default-homedir*  "k:/home/alowe/.gnupg")
; (setq *gpg-default-homedir*  "~/.gnupg")

(setq *gpg-encode-target* "Andrew")
(setq *gpg-extra-args* `("--homedir" ,*gpg-default-homedir*))

; find-script will look along path for certain commands 
(require 'path-utils)
(addpathp "/z/pl" "PATH")

; this ensure calendar comes up in a frame with a fixed-width font
; (load-library "mycal")

; xxx check out why this isn't autoloading
(load-library "post-bookmark")

; (load-library "post-help")
(load-library "fixframe")
(load-library "unbury")

(if (not (and
	  (file-directory-p exec-directory)
	  (string-match (format "%s.%s" emacs-major-version emacs-minor-version) exec-directory)))
    (let ((dir (or (getenv "EMACS_DIR") (getenv "EMACSDIR"))))
      (or (string= exec-directory dir)
	  (setq exec-directory dir))
      )
  )

(if (string-match "21" emacs-version)
    (fonty "tahoma"))

; (setq Info-default-directory-list '())
; (let (Info-dir-contents Info-directory-list) (info "/usr/share/info/dir"))

(setq Info-default-directory-list '("/usr/share/info" "/usr/share/emacs/info" "/usr/local/info" "/usr/local/lib/emacs-21.3/info"))
(setq Info-directory-list  Info-default-directory-list)

(defun flush-info-cache (dir)
  (setq Info-dir-contents-directory nil
	Info-dir-contents nil
	Info-directory-list nil)
  (info dir)
  )
; (flush-info-cache "/usr/share/info/dir")

(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

(scan-file-p "~/.private/.xdbrc")

; todo: get to the bottom of this
; xxx (add-to-list 'hooked-preloaded-modules "man")
; xxx (load-library "post-man")

; this is a problem..
(defun perl-font-lock-syntactic-keywords ()  perl-font-lock-syntactic-keywords) 

(require 'noted)
(require  'locations)
(require 'emacs-wiki-load)

(load-library "locate")

(add-to-load-path-p "/z/db" t)
;(require 'zt-loads)

