
; this is broken in pym.el if name is defined as an autoload.

(defmacro defun-maybe (name &rest everything-else)
  "Define NAME as a function if NAME is not defined.
See also the function `defun'."
  (or (and (fboundp name)
	   (not (get name 'defun-maybe))
	   (listp (symbol-function name))
	   (not (eq (car (symbol-function name)) 'autoload))
	   )
      `(or (fboundp (quote (, name)))
	   (prog1
	       (defun (, name) (,@ everything-else))
	     ;; This `defun' will be compiled to `fset',
	     ;; which does not update `load-history'.
	     ;; We must update `current-load-list' explicitly.
	     (setq current-load-list
		   (cons (quote (, name)) current-load-list))
	     (put (quote (, name)) 'defun-maybe t)))))


(provide 'defun-maybe)
