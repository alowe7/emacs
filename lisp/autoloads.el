(put 'autoloads 'rcsid
 "$Id: autoloads.el,v 1.11 2001-06-30 17:47:30 cvs Exp $")
; automatically generated for the most part.  see ../Makefile

(load "../.autoloads" t t t )

(mapcar
 '(lambda (x)
    (let ((f (concat x "/.autoloads")))
      (if (file-exists-p f) (load f t t t ))))
 load-path)

(load "outliers" t t)