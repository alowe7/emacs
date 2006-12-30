(put 'noted 'rcsid
 "$Id: noted.el,v 1.1 2006-12-30 00:39:37 noah Exp $")

; a version of noted for windows...

; tbd factor with tw/site-lisp/log.el

(defun glob (&rest args)
  (mapconcat '(lambda (arg) (format "%s" arg)) args " ")
  )
; (glob "b" 5 'c)

(defun noted (&rest args)
  (interactive (list (or current-prefix-arg (read-string "comment: "))))

  (if (listp (car args))
      (find-file *notedfile*)
    (let ((coding-system-for-write 'undecided-unix)
	  (text (apply 'glob args))
	  )
      (write-region (format "%s\t%s\t%s\t%s\n" (format-time-string "%s") (current-time-string) (buffer-file-name) text) nil  *notedfile* t 0)
      )
    )
  )

(defun did (&rest args)
  (interactive (list (or current-prefix-arg (read-string "comment: "))))

  (if (listp (car args))
      (find-file *didfile*)
    (let ((coding-system-for-write 'undecided-unix)
	  (text (apply 'glob args))
	  )
      (write-region (format "%s\t%s\t%s\n" (format-time-string "%s") (current-time-string) text) nil  *didfile* t 0)
      )
    )
  )

(defvar *notedfile* (expand-file-name "~/noted"))
(defvar *didfile* (expand-file-name "~/did"))