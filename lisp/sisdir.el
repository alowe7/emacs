(put 'sisdir 'rcsid
 "$Id$")

(defvar *sisdirs* nil "alist of related directories to cycle through using `sisdir'")

; 
(defun construct-sisdirs (base)
  " return a list that can be merged into *sisdirs*
"
  (remove* "CVS" (get-directory-files base) :test 'string=)
  )

; (setq *sisdirs* (construct-sisdirs "~/emacs/config/hosts"))
; (setq *sisdirs* '(("emacs/config/hosts/keystone" "emacs/config/hosts/tombstone")))

(defun sisdir ()
  (interactive)
  (let* ((dir default-directory)
	 (sub
	  (loop for x in *sisdirs* 
		when (string-match (car x) dir)
		return (concat 
			(substring dir 0 (match-beginning 0))
			(cadr x)
			(substring dir (match-end 0) )
			)
		when (string-match (cadr x) dir)
		return (concat 
			(substring dir 0 (match-beginning 0))
			(car x)
			(substring dir (match-end 0) )
			)
		)
	  )
	 (fn (buffer-file-name)))
    (cond (fn
	   (let ((other-file (expand-file-name (file-name-nondirectory fn)  sub)))
	     (cond ((file-exists-p other-file) (find-file-other-window other-file))
		   ((file-directory-p sub) (dired-other-window sub))
		   (t (message (format "%s does not exist" sub) )))
	     ))
	  (t  (cond ((file-directory-p sub) (dired-other-window sub))
		    (t (message (format "%s does not exist" sub) ))))
	  )
    )
  )

(define-key ctl-/-map "" 'sisdir)