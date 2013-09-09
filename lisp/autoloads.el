(put 'autoloads 'rcsid
 "$Id$")
; automatically generated for the most part.  see ../Makefile

(load "../.autoloads" t t t )

(defvar autoload-message t)
; (setq autoload-message nil)

(mapc
 (function (lambda (x)
    (let ((f (concat x "/.autoloads")))
      (if (file-exists-p f) (load f t autoload-message t )))))
 load-path)

(load "outliers" t t)
