(put 'host-init 'rcsid 
 "$Header: /var/cvs/emacs/config/hosts/alowe2/host-init.el,v 1.9 2001-08-24 19:20:58 cvs Exp $")

(if (file-directory-p "d:/x/elisp")
    (load "d:/x/elisp/.autoloads" t t t)
  )

(add-hook 'people-load-hook (lambda () 
			    (setq *people-database*
				  (mapcar 'expand-file-name
					  (list (concat (fw "broadjump") "/n/people")
						"~/n/people")))))

(require 'xz-loads)
(require 'gnuserv)

(setenv "XDBHOST" "kim.alowe.com")
(setenv "XDB" "x")
(setenv "XDBUSER" "a")

(lastworld)
