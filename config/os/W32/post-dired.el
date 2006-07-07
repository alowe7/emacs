(put 'post-dired 'rcsid
 "$Id: post-dired.el,v 1.2 2006-07-07 19:17:55 alowe Exp $")

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
  (let* ((f (funcall (if arg 'w32-canonify 'identity) (dired-get-filename))))
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

