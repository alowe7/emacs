(put 'cvs 'rcsid 
 "$Id: cvs.el,v 1.11 2003-08-29 16:50:28 cvs Exp $")
(require 'vc)
(require 'indicate)

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

(defvar cvs-command-history nil)

(defun cvs (cmd args)
  "execute a random cvs command"
  (interactive (list 
		(completing-read "CVS command: " *cvs-commands*)
		(string* (read-string (format "args (%s): " (indicated-filename))) (indicated-filename))))

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
	    

      (let* ((bname "*CVS*")
	     (b (get-buffer-create bname))
	     (cmd (format "cvs %s %s" cmd args)))
	(shell-command cmd b)
	(push cmd cvs-command-history)
	(if (buffer-exists-p bname) 
	    (progn (pop-to-buffer b)
		   (beginning-of-buffer)
		   (view-mode))
	  (message "command produced no output"))
	)

    (message nil)
    )
  )

(setq favorite-cvspservers '(("cvs@kim.alowe.com") ("cvs@kim")))


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
; (cvsroot)

(defun cvs-diff-version (v)
  "run cvs diff between the version in the current buffer and the specified REVISION"
  (interactive "sversion: ")
  (let ((f (file-name-nondirectory (buffer-file-name))))
    (cvs "diff" (format "-r %s %s" v f))
    )
  )

(define-key vc-prefix-map "1" 'cvs-diff-version) 

(defun cvs-update ()
  (interactive)
  (cvs "update" (file-name-nondirectory (buffer-file-name)))
  )
(define-key vc-prefix-map "." 'cvs-update) 

(defun cvs-find-file (f)
  "find a random file from the cvs tree"
  (interactive "sfile: ")
  (cvs "checkout" (concat "-p " f))
  )
(define-key vc-prefix-map "," 'cvs-find-file) 

(provide 'cvs)
