(put 'post-vc 'rcsid
 "$Id: post-vc.el,v 1.3 2003-09-23 16:01:43 cvs Exp $")

(chain-parent-file t)

(defvar *vc-graph-version-url* "http://olympus.inhouse.broadjump.com/cvsweb3/cvsweb.cgi%s/%s?graph=%s")

(defun cvs-repository () (or (read-file "CVS/Repository") (nth 3 (split (getenv "CVSROOT") ":"))))
(defun cvs-root () (or (read-file "CVS/Root") (getenv "CVSROOT")))

(defun vc-graph-version (&optional file revision) 
  "pop up a pretty revision graph of `buffer-file-name' (or `dired-get-filename' if in a dired buffer
with interactive arg, prompts for alternate version"
  (interactive "P")

  (let* ((file (cond (file file)
		     ((member major-mode '(dired-mode vc-dired-mode)) (dired-get-filename))
		     (t (buffer-file-name))))
	 (repository (cvs-repository))
	 (root (elt (split (cvs-root) ":") 3))
	 (revision (or revision (vc-workfile-version file))))
    (if (string-match root repository)
	(ie 
	 (format
	  *vc-graph-version-url*
	  (substring repository (match-end 0)) (file-name-nondirectory file) revision))
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
