
(chain-parent-file t)

(defvar *vc-graph-version-url* "http://olympus.inhouse.broadjump.com/cvsweb3/cvsweb.cgi%s/%s?graph=%s")

(defun vc-graph-version (arg) 
  "pop up a pretty revision graph of the `buffer-file-name'
with interactive arg, prompts for alternate version"
  (interactive "P")

  (let* ((f (if (eq major-mode 'dired-mode) (dired-get-filename) (buffer-file-name)))
	 (repository (read-file "CVS/Repository"))
	 (root (elt (split (read-file "CVS/Root") ":") 3))
	 (revision (cond (arg (read-string "revision: "))
			 (t (vc-workfile-version f)))))
    (if (string-match root repository)
	(ie 
	 (format
	  *vc-graph-version-url*
	  (substring repository (match-end 0)) (file-name-nondirectory f) revision))
      )))
(define-key vc-prefix-map "2" 'vc-graph-version)

(defun vc-info () 
  (interactive)
  (let* ((entries (loop for x in (split (read-file "CVS/Entries") "
")
			collect (cdr (split x "/"))))
	 (entry (assoc 
		 (file-name-nondirectory (buffer-file-name)) entries))
	 )

    (message 
     "%s %s %s %s"
     (elt entry 0) (elt entry 1) (elt entry 2) (substring (elt entry 4) 1) )

    )
  )
(define-key vc-prefix-map "/" 'vc-info)
