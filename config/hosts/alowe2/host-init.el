(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.12 2001-08-28 22:12:39 cvs Exp $")

(if (file-directory-p "d:/x/elisp")
    (load "d:/x/elisp/.autoloads" t t t)
  )

(let ((d "d:/x/elisp/play"))
      (mapcar '(lambda (x) (load (concat d "/" x) t t)) 
	      '("kill" "buff" "msvc" "syntax" "key" "show")))

;(get-directory-files d t "\.el$")

(add-hook 'after-init-hook '(lambda () 
			      (defadvice info (before 
					       hook-info
					       first 
					       activate)
				(cd "/")
				)))

(add-hook 'people-load-hook (lambda () 
			    (setq *people-database*
				  (mapcar 'expand-file-name
					  (list (concat (fw "broadjump") "/n/people")
						"~/n/people")))))


(display-time)

(require 'worlds)
(require 'world-advice)

(require 'xz-loads)
(setq *xz-show-status* nil)
(setq *xz-squish* 4)

(require 'gnuserv)

(setenv "XDBHOST" "kim.alowe.com")
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(lastworld)
