(put 'autoloads 'rcsid
 "$Id: autoloads.el,v 1.13 2006-03-22 22:53:33 alowe Exp $")
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
