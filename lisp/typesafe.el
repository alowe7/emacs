(put 'typesafe 'rcsid
 "$Id: typesafe.el,v 1.3 2005-02-09 16:36:24 cvs Exp $")

(require 'trim)

; todo: go back and fix all refs
(defmacro string* (**s** &optional **default**)
  "evaluates to STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (eval **s**))) (or (and (sequencep *s*) (> (length *s*) 0) *s*) (eval **default**))))

(defmacro number* (**n** &optional **default**)
  "evaluates to NUMBER if a numberp.
  if NUMBER is a string representation of a numberp, then reads the string value.
  otherwise returns optional DEFAULT.
 arguments are evaluated only once"
  (let ((*n* (eval **n**)))
    (cond
     ((numberp *n*) *n*)
     ((sequencep *n*)
      (let ((*n* (trim *n*)))
	(cond ((> (length *n*) 0)
	       (car (read-from-string (trim *n*))))
	      (t (eval **default**)))))
     (t (eval **default**))
     )
    )
  )

; alternative implementation:
(defun int* (str)
  "evaluates to integer value of STR if STR represents an integer, nil otherwise"

  (and (stringp str) (string-match "^[0-9]+" str) (eq (match-end 0) (length str)) (string-to-number str))
  )

(defmacro read-from-string* (**s** &optional **default**)
  "evaluates to intern STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (eval **s**))) (if (and (sequencep *s*) (> (length *s*) 0)) (car (read-from-string *s*))
				     (eval **default**))))

(provide 'typesafe)
