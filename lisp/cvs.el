(put 'cvs 'rcsid 
 "$Id: cvs.el,v 1.6 2001-04-27 11:37:59 cvs Exp $")
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
  "execute a random cvs command"
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
	    

      (let ((b (get-buffer-create "*CVS*")))
	(shell-command (format "cvs %s %s" cmd args) b)
	(pop-to-buffer b)
	(beginning-of-buffer)
	(view-mode)
	)

    (message nil)
    )
  )

(setq favorite-cvspservers '(("cvs@kim.technology-x.com") ("cvs@kim")))


(defun cvsroot (&optional arg)
  "get or set current CVS/Root.
if interactive without optional ARG, just display it.
else if interactive, prompt for and set it.

non-interactive arg is a string to set it to
"

  (interactive "P")

  (let ((msg
	 (cond ((! (-d "CVS"))
		"error: no CVS version here")
	       ((! (-f "CVS/Root"))
		"error: no CVS/Root here")
	       (arg
		(let* ((cvsroot 
			(apply 'vector (split (read-file "CVS/Root" t) ":")))
		       (newroot
			(or (and (not (interactive-p)) (string* arg) arg)
			    (completing-read
			     (format "new root [%s]: " (aref cvsroot 2))
			     favorite-cvspservers nil t "cvs@"))))

		  (if (string* newroot)
		      (progn
			(aset cvsroot 2 newroot)
			(write-region (join cvsroot ":") nil "CVS/Root"))
		    (join cvsroot ":"))
		  )
		)
	    
	       (t
		(read-file "CVS/Root" t))
	       )))

    (if (interactive-p) (message msg) msg)

    )
  )
; (cvsroot)]