(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.10 2001-08-28 21:37:58 cvs Exp $")

(if (file-directory-p "d:/x/elisp")
    (load "d:/x/elisp/.autoloads" t t t)
  )

(let ((d "d:/x/elisp/play"))
      (mapcar '(lambda (x) (load x t t)) 
	      (get-directory-files d t "\.el$")))

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
(require 'gnuserv)

(setenv "XDBHOST" "kim.alowe.com")
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(lastworld)
