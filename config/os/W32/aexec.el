(put 'aexec 'rcsid
 "$Id$")

; (aexec-handler "jar")

(defun aexec-handler (ext)
  "helper function to find a handler for ext, if any"
  (and ext 
       (assoc (downcase ext) file-assoc-list)
       )
  )

(defvar *aexec-process-abnormal-exit-debug* nil "when set, invoke debugger if aexec process exits abnormally")

(defun aexec-sentinel (p s)
  "sentinel called from when processes created by `aexec-start-process' change state
if the new state is 'finished', deletes the associated buffer
"

  (cond ((or (string= (chomp s) "finished") (not  *aexec-process-abnormal-exit-debug*))
	 (let ((b (process-buffer p)))
	   (if (buffer-live-p b)
	       (kill-buffer b))
	   ))
	((string-match "^exited abnormally" (chomp s))
	 (let ((aexec-process-parameters (get 'aexec-process-sentinel 'parameters)))
	 (debug)))
	(t  (debug))
	)
  )

(defun aexec-start-process (cmd f)
  "create process running COMMAND on input FILE
name is generated from basename of command
process is given an output buffer matching its name and a sentinel `aexec-sentinel'
"

  (unless (and (string* (trim cmd)) (string* (trim f)))
    (debug)
    )

  (let* ((name (symbol-name (gensym (downcase (basename cmd)))))
	 (buffer-name (generate-new-buffer-name name))
	 p)
    (setq p (start-process name buffer-name cmd (w32-canonify f)))
    (put 'aexec-process-sentinel 'parameters (list name buffer-name cmd f))
    (set-process-sentinel p 'aexec-sentinel)		 
    )
  )

(defun aexec (f &optional visit)
  "apply command associated with filetype to specified FILE
filename may have spaces in it, so double-quote it.
handlers may be found from the variable `file-assoc-list' or 
failing that, via `file-association' 
if optional VISIT is non-nil and no file association can be found just visit file, otherwise
 display a message  "
  (interactive "sFile: ")
  (let* ((ext (file-name-extension f))
	 (default-directory (or (file-name-directory f) default-directory))
	 (handler 
	  (or     
	   (aexec-handler ext)
	   (progn
	     (condition-case x
		 (require (intern (format "%s-view" ext)))
	       (file-error nil))
	     (aexec-handler ext)
	     ))))
    (if handler (funcall (cdr handler) f)
      (let ((cmd (file-association f)))
	(cond
	 (cmd
	  (aexec-start-process cmd f))
	 (visit (find-file f))
	 (t (progn
	      (message
	       "no handler for type %s ... " 
	       (file-name-extension f))
	      (sit-for 0 500)

	      (let ((doit (y-or-n-q-p "explore %s [ynqv ]? " " v" f)))
		(cond
		 ((or (eq doit ?y) (eq doit ? ))
		  (explore f))
		 ((eq doit ?v)
		  (message "visiting file %s ..." f)
		  (sit-for 0 800)
		  (find-file f)))
		)
	      (message ""))
	    )
	 )
	)
      )
    )
  )

(provide 'aexec)
