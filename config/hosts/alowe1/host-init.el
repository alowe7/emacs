(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe1/host-init.el,v 1.3 2003-03-19 15:26:53 cvs Exp $")

(setq default-frame-alist
      '((top . 23)
	(left . 33)
	(width . 116)
	(height . 48)
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
				    (nconc 
; xxx todo: put (get-directory-files (expand-file-name ...)) into xwf if F is a dir, add optional argz
				     (last (get-directory-files (xwf "n" "broadjump") t "people.*\.csv$"))
				     (list "~/n/people")))))
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

			      (load "world-advice")
			      (load "post-worlds")
			      )
	  )

(setq *shell-track-worlds* t)

(scan-file-p "~/.xdbrc")

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

(mapcar '(lambda (f) (apply f '(comint-prompt-regexp "^[a-zA-Z0-9]+[>$%] *"))) '(set-default set))

(setq *default-swordfile* "~/.private/bj")

; man don't work with default path
(load-library "post-man")

(setq grep-command "grep -n -i -e ")

(setq font-lock-support-mode 'lazy-lock-mode)

(add-hook 'perl-mode-hook (lambda () (lazy-lock-mode)))

(defvar java-home
  (string* (getenv "JAVA_HOME")
	   (expand-file-name
	    (chomp (queryvalue "machine" "software/javasoft/java development kit/1.4" "javahome")))
	   )
  )
