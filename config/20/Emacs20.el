(put 'Emacs20 'rcsid
 "$Id: Emacs20.el,v 1.2 2005-02-09 16:36:24 cvs Exp $")

(defmacro read-from-env (**v** &optional **default**)
  "evaluates to intern STRING if non-null and nonzero length, else DEFAULT.
 arguments are evaluated only once"
  (let ((*s* (getenv (eval **v**)))) (if (and (sequencep *s*) (> (length *s*) 0)) (car (read-from-string *s*))
				     (eval **default**))))


(defun env (v)
  "insert value of environment variable V"
  (interactive "svar: ")
  (insert (getenv v)))

(defun unset (v)
  "remove environment variable V from `process-environment'
if V is a list, remove all elements of the list
returns a copy of process-environment
does not affect currently running environment"
  (interactive "svar: ")

  (let ((vl (if (stringp v) (list v) v)))
    (loop for v in vl
	  with ret = process-environment
	  do (setq ret (remove* v ret :test '(lambda (x y) (string= x (car (split y "="))))))
	  finally return ret)
    )
  )
