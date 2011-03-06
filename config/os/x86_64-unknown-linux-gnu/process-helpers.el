(put 'process-helpers 'rcsid
 "$Id: process-helpers.el 890 2010-10-04 03:34:24Z svn $")

(defun collect-process-like (cmd &optional arg)
  "collect processes with process-command matching CMD.
with optional ARG, process must have at least one argument matching
"
  (loop for x in (process-list) 
	when (and (string-match cmd (car (process-command x)))
		  (or (null arg) (loop for y in (cdr (process-command x)) thereis (string-match arg y))))
	collect x)
  )

(defun signal-process-like (pat &optional sig arg)
  "signal the first process found with command matching PATTERN
with optional SIGNAL sends that.  default is 'hup
with optional third ARG process must have at least one matching argument
"
  (interactive "ssignal process like: ")

  (let ((pl (collect-process-like pat))
	(sig (or sig 'hup)))

    (cond ((null pl)
	   (cond ((interactive-p) (message (format "no process like %s found" pat)))))
	  (t
	   (let ((p (car pl)))
	     (cond ((processp p)
		    (signal-process p sig))
		   )
	     )))
    )
  )
; (signal-process-like "nautilus")

(provide 'process-helpers)
