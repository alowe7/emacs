(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/nathan/host-init.el,v 1.10 2004-09-24 02:08:07 cvs Exp $")

(setq default-fontspec "-*-tahoma-normal-r-*-*-16-*-*-*-*-*-*-*-")

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

(setq *people-database*  '("/a/n/people"))

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

; man don't work with default path
(load-library "post-man")
(defvar mandirs (catlist (getenv "MANPATH") ?;))

(setq font-lock-support-mode 'lazy-lock-mode)
(add-hook 'perl-mode-hook (lambda () (lazy-lock-mode)))
(add-hook 'java-mode-hook (lambda () (lazy-lock-mode)))

; (load-library "post-help")
(load-library "fixframe")
(load-library "unbury")

(add-to-load-path "/u/emacs-w3m-1.3.2")
(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)

(add-to-load-path "/z/el" t)
(load-library "mycal")

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

(setq Info-default-directory-list '("/usr/share/info" "/usr/share/emacs/info" "/usr/local/info"))
(setq Info-directory-list  Info-default-directory-list)

(defun flush-info-cache (dir)
  (setq Info-dir-contents-directory nil
	Info-dir-contents nil
	Info-directory-list nil)
  (info dir)
  )
; (flush-info-cache "/usr/share/info/dir")

(setenv "INFOPATH" "/usr/share/info")
; (setenv "INFOPATH" "/usr/share/emacs/info/")

(autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
(autoload 'xml-mode "psgml" "Major mode to edit XML files." t)
