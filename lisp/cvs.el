(put 'cvs 'rcsid 
 "$Id: cvs.el,v 1.1 2000-10-18 20:13:42 cvs Exp $")
(provide 'cvs)

(defvar *cvs-commands*
  '(("checkout")
    ("commit" "-m")
    ("diff")
    ("export")
    ("history")
    ("import")
    ("log")
    ("rdiff")
    ("release")
    ("update")
    ))

(defun cvs (cmd args)
  (interactive (list 
		(completing-read "CVS command: " *cvs-commands*)
		(read-string "args: ")))
  ;; check required args
  (if (catch 'err
	(loop for x in 
	      (cdr (assoc cmd *cvs-commands*))
	      do 
	      (or
	       (and args (string-match x args))
	       (y-or-n-p
		(format "arg %s not found in <%s>.  continue (y/n)? " x args))
	       (throw 'err nil))
	      )
	t
	)
	    

      (let ((b (zap-buffer "*CVS")))
	(shell-command (format "cvs %s %s" cmd args) b)
	(pop-to-buffer b)
	(beginning-of-buffer)
	)

    (message nil)
    )
  )


