(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe1/host-init.el,v 1.17 2004-03-03 15:15:18 cvs Exp $")

(setq default-frame-alist
      '((top . 100)
	(left . 100)
	(width . 114)
	(height . 40)
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

(setq initial-frame-alist
      '((top . 135)
	(left . 221)
	(width . 90)
	(height . 40)
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
	(menu-bar-lines . 0)))

(add-hook 'people-load-hook (lambda () ; (require 'worlds)
			      (setq *people-database*
				    (nconc 
; xxx todo: put (get-directory-files (expand-file-name ...)) into xwf if F is a dir, add optional argz
;				     (last (get-directory-files (xwf "n" "broadjump") t "people.*\.csv$"))
				     (last (get-directory-files "/m" t "phone.*\.csv$"))
				     (list "~/n/people")))))
(add-hook 'xz-load-hook 
	  '(lambda ()
	     (mapcar
	      '(lambda (x) (load x t t)) 
		     '("xz-compound" "xz-fancy-keys" "xz-constraints"))))

(add-hook 'world-init-hook '(lambda ()
;; 
;; 			      (setq *howto-path* 
;; 				    (loop for w in (la) 
;; 					  when (file-exists-p (fwf "n" w))
;; 					  collect (fwf "n" w)))
;; 
;; 			      (setq *howto-alist* 
;; 				    (loop
;; 				     for x in *howto-path*
;; 				     with l = nil
;; 				     nconc (loop for y in (get-directory-files x)
;; 						 collect (list y x)) into l
;; 				     finally return l)
;; 				    )

; 			      (load "world-advice")
			      (load "post-worlds")
			      )
	  )

(setq *shell-track-worlds* t)

; this is so wrong...
; (scan-file-p "~/.xdbrc")
(setq *txdb-options* '("-b" "a/q-1pzl@x" "-h" "localhost:13306"))

; (add-hook 'xdb-init-hook 'xdb-login)

(if (and (not (evilnat)) 
	 (string* (getenv "XDBHOST"))
	 (string* (getenv "XDBDOMAIN"))
	 (not (string-match (getenv "XDBDOMAIN") (getenv "XDBHOST"))))
    (setenv "XDBHOST" (concat (getenv "XDBHOST") "." (getenv "XDBDOMAIN"))))

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(setq gnus-select-method '(nntp "news.inhouse.broadjump.com"))
; (setenv "NNTPSERVER" "news.inhouse.broadjump.com")

(require 'gnuserv)
(display-time)

(make-variable-buffer-local 'shell-prompt-pattern)
(set-default 'shell-prompt-pattern
	     (set 'shell-prompt-pattern "^[a-zA-Z0-9]+[>$%] *"))

(setq *default-swordfile* "~/.private/bj")

; man don't work with default path
(load-library "post-man")

(setq grep-command "grep -n -i -e ")

(setq font-lock-support-mode 'lazy-lock-mode)

(add-hook 'perl-mode-hook (lambda () (lazy-lock-mode)))
(add-hook 'java-mode-hook (lambda () (lazy-lock-mode)))

(require 'reg)

(defvar java-home
  (string* (getenv "JAVA_HOME")
	   (expand-file-name
	    (chomp (queryvalue "machine" "software/javasoft/java development kit/1.4" "javahome")))
	   )
  )

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

(require 'worlds)
(let ((lw (read-file (concat wbase "/" *lastworld-file-name*)))) (and lw (world lw)))
(setq *log-file-save* t)
(and  *log-file-save*
      (add-hook 'after-save-hook 'world-file-save-hook))

(load-library "post-help")

