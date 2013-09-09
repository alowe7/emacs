(put 'rcs 'rcsid 
 "$Id$")
(provide 'rcs)

(defvar *checkin-verify* nil)

(defun rcs-command (cmd)
  (interactive "sCommand: ")
  (let ((b (zap-buffer "*RCS*")))
    (shell-command cmd b)
    (pop-to-buffer b)
    (goto-char (point-min))
    )
  )

(defun rcsdiff (file)
  (interactive "fFile: ")
  (rcs-command (format "rcsdiff -w %s" file))
  )

(defun checkin (filename comment) 
  (interactive "sFilename: \nsComment:")

  (and filename
       (> (length filename) 0)

       (let ((tmpfilename (format "%s/__rcstmp" (getenv "TMP")))
	     (outbuf (zap-buffer " *RCSOUT*")))

	 (let ((b (generate-new-buffer " *RCS*")))
	   (with-current-buffer b
	     (insert comment)
	     (write-file tmpfilename)
	     )
	   (kill-buffer b))

	 (if (or (not *checkin-verify*)
		 (y-or-n-p (format "check in file %s? " f)))

	     (cond ((eq (call-process
			 "ci"
			 tmpfilename
			 (list outbuf t)
			 nil
			 (format "-w%s" (getenv "LOGNAME"))
			 filename) 
			0)
		    (kill-buffer outbuf) ;kill buffer containing process output
		    (let ((fb (get-file-buffer filename)))
		      (and fb
			   (y-or-n-p (format "file %s successfully checked in.  kill buffer? " filename))
			   (kill-buffer fb) ;kill file's buffer
			   ))
		    t)
		   (t
		    (message (format "Errors in process: %s" (with-current-buffer outbuf (buffer-string))))
		    nil))
	   )
	 )
       )
  )


(defun dired-checkin ()
  (interactive)

  (let* ((f (dired-get-filename t))
	 (b (get-file-buffer f)))
    (and
     (if b 
	 (with-current-buffer b
	   (checkin-current-file))
       (checkin f (read-string "Comment: ")))
     (revert-buffer) ; if checkin worked, update buffer list
     )

    (message "")
    )
  )

(defun checkin-current-file ()
  (interactive)

  (prog1
      (let ((f (buffer-file-name (current-buffer))))
	(and
	 (or 
	  (not (buffer-modified-p))
	  (if
	      (y-or-n-p (format "buffer %s is modified.  save before checkin? " (buffer-name)))
	      (progn (save-buffer) t)
	    ))
	 (checkin f (read-string "Comment: "))))
    (message ""))
  )

(defun lock-current-file ()
  (interactive)
  "acquire a lock on the file currently being edited."
  (let ((f (buffer-file-name (current-buffer))))
    (and f
	 (or 
	  (not (buffer-modified-p))
	  (if
	      (y-or-n-p (format "buffer %s is modified.  save before checkin? " (buffer-name)))
	      (progn (save-buffer) t)
	    ))
	 (rcs-command (concat "checkout -l " f))))
  (message "")
  )


(defun lsrcs ()
  (interactive)
  "list files in current rcs directory"
  (if (file-directory-p "RCS")
      (rcs-command "lsrcs")
    (message "no RCS directory in %s" (pwd))))

(defun cancel-checkout (filename) 
  (interactive  "sFilename: ")
  (rcs-command (concat "rcs-cancel-checkout " filename))
  )


(if (not (fboundp 'ctl-C-ctl-I-prefix)) 
    (define-prefix-command 'ctl-C-ctl-I-prefix))
(global-set-key "	" 'ctl-C-ctl-I-prefix)

(let ((map (symbol-function 'ctl-C-ctl-I-prefix)))
  (define-key map "	" (function (lambda () (interactive)
			     (call-interactively
			      (cond ((eq major-mode 'dired-mode)
				     'dired-checkin)
				    ((and (buffer-file-name)
					  (y-or-n-p "Checkin current file? "))
				     'checkin-current-file)
				    (t 'checkin))))))
  (define-key map "" 'lsrcs)
  )

(defun rlog (filename) (interactive "sFilename: ")
  (rcs-command (concat "rlog " filename)))
