

(defun aexec (f &optional visit)
  "apply command associated with filetype to specified FILE
filename may have spaces in it, so double-quote it.
handlers may be found from the variable `file-assoc-list' or 
failing that, via `file-association' 
if optional VISIT is non-nil and no file association can be found just visit file, otherwise
 display a message  "
  (interactive "sFile: ")
  (let* ((ext (condition-case x (downcase (file-name-extension f)) (wrong-type-argument nil)))
	 (handler (assoc ext file-assoc-list)))

    (if handler (funcall (cdr handler) f)
      (message "handler not found"))
    )
  )