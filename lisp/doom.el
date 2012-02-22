(put 'doom 'rcsid
 "$Id$")

(defvar *doomdir* "/doomed")

(defun doom (&optional arg)
  "soft delete files or directories
if in `dired-mode' take from `dired-get-marked-files' 
otherwise prompts for file, using `buffer-file-name' as default
doomed files are stored into *doomdir* under datestamped directories.
interactive with prefix arg, uses most recently used *doomdir*
most recently doomed files or directories are pushed onto the kill ring (see `kill-new')
"
  (interactive "P")
  (let* ((fnlst (cond ((eq major-mode 'dired-mode)
		       (dired-get-marked-files))
		      (t (list (read-file-name* "filename (%s): " (buffer-file-name)))
			 )))
	 (datestamp (eval-process "date +%y%m%d%H%M%S"))
	 (dir (if arg
					; use most recent dir
		  (expand-file-name
		   (car (reverse (sort (get-directory-files *doomdir* "^[0-9]+") 'string=)))
		   *doomdir*)
					;create a new one
		(let ((dir (format "%s/%s" *doomdir* datestamp)))
		  (make-directory dir t)
		  dir)
		)
	      )
	 (newfnlst (loop for fn in fnlst collect (list fn (expand-file-name
							   (file-name-nondirectory fn)
							   dir))))
	 )

    (loop for x in newfnlst do
	  (let ((fn (car x)) (newfn (cadr x)))
	    (condition-case err
		(rename-file fn newfn)
	      (message (kill-new newfn))
	      (file-already-exists
					; tbd: (y-or-n-p (format "%s %s.  continue?" (cadr err) (caddr err)))
	       (debug)
	       ))
	    ))
    (and (eq major-mode 'dired-mode) (revert-buffer))
    )
  )

(defvar *share* "/share")

(defun share (fn)
  "create a directory in `*share*' based on current datestamp and copy FILE in there
defaults for file are `dired-get-filename' if in `dired-mode' otherwise `buffer-file-name'
"
  (interactive (list
		(read-file-name* "filename (%s): " 
				   (cond ((eq major-mode 'dired-mode)
					  (dired-get-filename))
					 (t (buffer-file-name))
					 ))))

  (cond ((string* fn)
	 (let* ((datestamp (eval-process "date +%y%m%d"))
		(share *share*)
		(dir (format "%s/%s" share datestamp))
		(newfn (expand-file-name
			(file-name-nondirectory fn)
			dir))
		)
	   (unless (file-directory-p dir)
	     (shell-command (format "mkdir -p %s" dir)))
	   (cond 
	    ((or (not (file-exists-p newfn))
		 (y-or-n-p (format "%s exists.  overwrite (y/n) ? " newfn)))
	     (copy-file fn newfn t t)
	     (message (kill-new newfn)))
	    (t (message (format "%s not written." newfn))))
	   ))
	(t (message " file not specified")))
  )

(defun snap (fn)
  (interactive (list
		(read-file-name* "filename (%s): " 
				 (cond ((eq major-mode 'dired-mode)
					(dired-get-filename))
				       (t (buffer-file-name))
				       ))))

  (let* ((datestamp (eval-process "date +%y%m%d"))
	 (share "/backup/snap")
	 (dir (format "%s/%s" share datestamp))
	 (newfn (expand-file-name
		 (file-name-nondirectory fn)
		 dir))
	 )
    (shell-command (format "mkdir -p %s" dir))
    (copy-file fn newfn)
    (message (kill-new newfn))
    )
  )



