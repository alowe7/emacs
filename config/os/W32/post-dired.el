(put 'post-dired 'rcsid
 "$Id: post-dired.el,v 1.5 2007-04-03 19:21:13 noah Exp $")

; tbd promote these...

; i think this is actually broken in os-init
(defun w32-canonify (f &optional sysdrive)
  " expands FILENAME, using backslashes
optional DRIVE says which drive to use. "
  (replace-in-string  "/" "\\" 
		      (if sysdrive (expand-file-name 
				    (substitute-in-file-name
				     (chomp f ?/))
				    (and (string* sysdrive) (concat sysdrive "/")))
			(substitute-in-file-name
			 (chomp f ?/))
			)
		      )
  )

(defun dired-copy-filename-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((of (or (dired-get-filename nil t) default-directory))
	 (f (funcall (if arg 'w32-canonify 'identity) of)))
    (kill-new f)
    (if (interactive-p) (message f))
    )
  )
(define-key dired-mode-map "\C-cw" 'dired-copy-filename-as-kill)

(defun dired-copy-directory-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((f (funcall (if arg 'w32-canonify 'identity) (dired-current-directory))))
    (kill-new f)
    (if (interactive-p) (message f))
    )
  )

(define-key dired-mode-map "\C-c\C-x\C-c" 'dired-copy-directory-as-kill)


; override to expand default-directory... w32 only

(defun dired-read-dir-and-switches (str)
  ;; For use in interactive.
  (reverse (list
	    (if current-prefix-arg
		(read-string "Dired listing switches: "
			     dired-listing-switches))
	    (read-file-name (format "Dired %s(directory): " str)
			    nil (expand-file-name default-directory) nil))))
