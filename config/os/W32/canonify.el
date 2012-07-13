(put 'canonify 'rcsid
 "$Id$")

(defun w32-canonify (f &optional sysdrive)
  " expands FILENAME, using backslashes
optional DRIVE says which drive to use. "

  (cond
   ((string= f "/") "\\")
   ((string-match "\\(file:\\)?///\\(.\\)\|\\(.*\\)$" f)
    (concat (match-string 2 f) ":" (match-string 3 f)))
   (t
    (replace-regexp-in-string  "/" "\\\\" 
			       (replace-regexp-in-string  "//" "\\\\\\\\" 
							  (if sysdrive (expand-file-name 
									(substitute-in-file-name
									 (chomp f ?/))
									(and (string* sysdrive) (concat sysdrive "/")))
							    (substitute-in-file-name
							     (chomp f ?/))
							    )
							  )
			       )
    )
   )
  )
; (w32-canonify "file:///C|/home/a/.private/proxy.pac")
;(w32-canonify "/a/b/c")
;(w32-canonify "/")
;(w32-canonify "/tmp" "c:")
(fset 'unc-canonify 'w32-canonify)

(defun unix-canonify (f &optional mixed)
  " expands FILENAME, using forward slashes.
if FILENAME is a list, return the list of canonified members
optional second arg MIXED says do not translate 
letter drive names.
if MIXED is 0, then ignore letter drive names.
"
  (if (listp f)
      (loop for x in f collect (unix-canonify x mixed))
    (let* 
	((default-directory "/")
	 (f (expand-file-name (substitute-in-file-name f))))
      (if (null mixed)
	  f
	(let
	    ((m (string-match "^[a-zA-Z]:" f)))
	  (if (eq mixed 0)
	      (substring f (match-end 0))
	    (concat "//" (upcase (substring f 0 1)) (substring f (match-end 0)))
	    )
	  )))
    )
  )

(defun unix-canonify-0 (f) (unix-canonify f 0))

(defalias 'canonify 'unix-canonify)



(defun unix-canonify-region (beg end)
  (interactive "r")
  (kill-region beg end)
  (insert (unix-canonify (expand-file-name (car kill-ring))))
  )

(defun split-path (&optional path)
  (let ((path (or path (getenv "PATH"))))
    (split (unix-canonify-path path) ":")
    )
  )

(defun unix-canonify-env (name)
  "`unix-canonify-path' on value of environment variable NAME and push result onto `process-environment'"
  (push 
   (concat name "="
	   (unix-canonify-path
	    (cadr (split (loop for x in process-environment when (string-match (concat "^" name "=") x) return x) "="))
	    )
	   )
   process-environment 
   )
  )

(defun unix-canonify-path (path)
  " `unix-canonify' elements of w32 style PATH"
  (join (mapcar #'(lambda (x) (unix-canonify x 0)) (split  path ";")) ":")
  )




(defun w32-canonify-region (beg end)
  (interactive "r")
  (kill-region beg end)
  (insert (w32-canonify (expand-file-name (car kill-ring))))
  )

(defun w32-canonify-env (name)
  "`w32-canonify-path' on value of environment variable NAME and push result onto `process-environment'"
  (push (concat name "="
		(w32-canonify-path
		 (cadr (split (loop for x in process-environment when (string-match (concat "^" name "=") x) return x) "="))
		 )
		)
	process-environment
	)
  )

(defun w32-canonify-path (path &optional drive)
  " `w32-canonify' elements of w32 style PATH"
  (join (mapcar #'(lambda (x) (w32-canonify x drive)) (split  path ":")) ";")
  )
; (w32-canonify-path (getenv "PATH"))


(provide 'canonify)
