(put 'autoloads 'rcsid
 "$Id: autoloads.el,v 1.12 2001-08-24 19:20:58 cvs Exp $")
; automatically generated for the most part.  see ../Makefile

(load "../.autoloads" t t t )

(defvar autoload-message t)
; (setq autoload-message nil)

(mapcar
 '(lambda (x)
    (let ((f (concat x "/.autoloads")))
      (if (file-exists-p f) (load f t autoload-message t ))))
 load-path)

(load "outliers" t t)