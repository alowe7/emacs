(put 'mime 'rcsid "$Id: mime.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
(defvar *mime-associations* 
	(read
	 (perl-command "/a/bin/list-mime-types" "-l"))
 "associations of file types to mime types in registry")

(defun mime-association  (file)
  "evaluates to MIME type associated with file"
  (cdr (assoc
	 (concat "." (downcase (file-name-extension file)))
	*mime-associations* )))

;; (defun mime-association  (f &optional notrim)
;; 	"find command associated with filetype of specified file"
;; 	(interactive "sFile: ")
;; 	(let* ((ext (assoc  (downcase f) *mime-associations*))
;; 				 (ocmd (and ext (file-association (cadr ext)))))
;; 		(cond ((null ocmd)
;; 					 (and
;; 						(message "no association for file: %s" f)
;; 						nil))
;; 					(notrim ocmd)
;; 					(t (string-to-word ocmd)))
;; 		;; sometimes command line args are appended to ocmd.
;; 		;; we usually want just the executable
;; 		)
;; 	)

(defun mimeexec (m) (interactive "smime type: ")
	"find command associated with mime type"
	(let ((cmd (mime-association m)))
		(and cmd (start-process f nil "cmd" "/c" cmd f)))
)

; (mime-association "application/msword" t)

;; some more vm helpers
(defun vm-mime-find-external-viewer (type)
(mime-association type)
)

(defun vm-mime-display-external-generic (layout)

	(let ((tempfile (mktemp "foob")))
		(set-buffer (marker-buffer (vm-mm-layout-body-start layout)))
(debug)
	(save-excursion
	  (save-restriction
	    (widen)

		(write-region
		 (vm-mm-layout-body-start layout)
		 (vm-mm-layout-body-end layout)
		 tempfile nil 0)
))
		(mimeexec tempfile)
		)
	)