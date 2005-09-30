(put 'post-comint 'rcsid
 "$Id: post-comint.el,v 1.5 2005-09-30 20:19:10 cvs Exp $")

(require 'whencepath)

(chain-parent-file t)

(defvar *ps-command*)
(set-default '*ps-command* (whence "ps"))
(make-variable-buffer-local '*ps-command*)

(defun processes ()
  (let ((l1 (split (eval-process  *ps-command*) "
")))
    (loop for x in (cdr l1)
	  collect 
	  (let ((l (split x "[ 	]+")))
	    (nconc (list 
		    (car (read-from-string (elt l 1)))
		    (car (read-from-string (elt l 2)))
		    (car (read-from-string (elt l 3)))
		    (car (read-from-string (elt l 4)))
		    (car (read-from-string (elt l 5)))
		    (car (read-from-string (elt l 6))))
		   (nthcdr 6 l))
	    )
	  )
    )
  )
; (processes)


(add-to-list 'comint-output-filter-functions 'comint-watch-for-password-prompt)
