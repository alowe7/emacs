(put 'aexec 'rcsid
 "$Id$")

(require 'typesafe)

(defun w32-substitute-in-file-name (file)
  "expand windows style environment variables in FILE
"
  (let ((file 
	 (loop while (string-match "%[a-zA-Z][a-zA-Z0-9]*%" file) do
	       (let ((env-var (substring file (1+ (match-beginning 0)) (1- (match-end 0)))))
		 (setq file (replace-match (concat "$" env-var) nil nil file))
		 )
	       finally return file
	       )))
    (canonify file)
    )
  )
; (let ((file (elassoc ".jpg"))) (w32-substitute-in-file-name file))

(defun w32-substitute-parameters (file &rest parameters)
  "expand windows style environment variables in FILE
"

  (loop with n = 1
	for parameter in parameters
	do
	(if (string-match (format "%%%d" n) file)
	    (setq file (replace-match parameter nil nil file))
	  )
	(setq n (1+ n))
	finally return file
	)
  )
; (assert (string= (w32-substitute-parameters "program %1 /switch %2" "foo" "bar") "program foo /switch bar"))

; this is w32 specific, need to factor for workalike on other platforms?
(defun elassoc (ext)
  "find file-association for extension"
  (let* ((ext (if (string-match "^\\." ext) ext (concat "." ext)))
	 (class (eval-process "regtool" "get" (format "/HKLM/SOFTWARE/Classes/%s/" ext)))
	 (program (eval-process "regtool" "get" (format "/HKLM/SOFTWARE/Classes/%s/shell/open/command/" class))))
    program
    )
  )
; (assert (string= (elassoc "docx") (elassoc ".docx")))
; (elassoc ".doc")
; (elassoc ".jpg")

(defun file-association (f &optional notrim)
  "find command associated with filetype of specified file"
  (interactive "sFile: ")
  (elassoc (file-name-extension f))
  )
; (file-association ".jpg")
; (file-association "foo.doc" t)
; (file-association "foo.el" t)

(defun aexec-handler (ext)
  "helper function to find a handler for ext, if any"
  (and ext 
       (assoc (downcase ext) file-assoc-list)
       )
  )
; (aexec-handler "jar")

(defvar *aexec-process-abnormal-exit-debug* nil "when set, invoke debugger if aexec process exits abnormally")

(defun aexec-sentinel (p s)
  "sentinel called from when processes created by `aexec-start-process' change state
if the new state is 'finished', deletes the associated buffer
"
  (debug)
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


(defun aexec-start-process (cmd &optional f)
  "create process running COMMAND on input FILE
name is generated from basename of command
process is given an output buffer matching its name and a sentinel `aexec-sentinel'
"

  (let ((cmd (w32-substitute-in-file-name cmd)))
      (debug)
    (cond
     ((and cmd (file-exists-p cmd))
  ; cmd is a plain file name.  apply it to file

      (unless (and (string* (trim-white-space-string cmd)) (string* (trim-white-space-string f)))
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
     (cmd
  ; cmd is defined, but is not a plain file name.  try substituting parameter 
      ;; todo: factor this with clause above

      (let* (
	     (cmd (w32-substitute-parameters cmd f))
	     (cmdlist (split cmd))
	     (name (symbol-name (gensym (downcase (basename cmd)))))
	     (buffer-name (generate-new-buffer-name name))
	     p)
	(setq p (apply 'start-process (nconc (list name buffer-name (car cmdlist)) (cdr cmdlist))))
	(put 'aexec-process-sentinel 'parameters (list name buffer-name cmd))
	(set-process-sentinel p 'aexec-sentinel)		 
	)
      )
     (t
      (error "file association for %s not found f")
      )
     )
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
	 (handler (aexec-handler ext))
	 )
    (if handler (funcall (cdr handler) f)
      (let ((cmd (file-association f)))
	(condition-case err
	    (cond
	     (cmd
	      (aexec-start-process cmd f))

	     (visit
  ; cmd is not defined, but visit is set
	      (find-file f))

	     ;; error situation
	     (t (progn
		  (message
		   (if cmd 
		       "handler for type %s not found... " 
		     "no handler for type %s ... " )
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
  ; shouldn't happen 
	  (file-error
	   (debug))
	  )
	)
      )
    )
  )

(provide 'aexec)
