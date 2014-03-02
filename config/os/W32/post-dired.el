(put 'post-dired 'rcsid
 "$Id$")

(chain-parent-file t)

; tbd promote these...

(defun dired-copy-filename-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((of (or (dired-get-filename nil t) default-directory))
	 (f (funcall (if arg 'w32-canonify 'identity) of)))
    (kill-new f)
    (if (called-interactively-p 'any) (message f))
    )
  )
(define-key dired-mode-map "\C-cw" 'dired-copy-filename-as-kill)

(defun dired-copy-directory-as-kill (arg) 
  "apply `kill-new' to `dired-get-filename'"
  (interactive "P")
  (let* ((f (funcall (if arg 'w32-canonify 'identity) (dired-current-directory))))
    (kill-new f)
    (if (called-interactively-p 'any) (message f))
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



(when (fboundp 'explore)

  (defun dired-aexec () 
    "invoke `aexec' on `dired-get-filename' unless it is a `file-directory-p', in which case, invoke `explore'
"
    (interactive)
    (cond
     ((file-directory-p (dired-get-filename))
      (explore (dired-get-filename)))
     (t
      (aexec
       (dired-get-filename)
       )
      )
     )
    )
  (define-key dired-mode-map "\C-m" 'dired-aexec)
  ;			      (define-key dired-mode-map "\C-m" 'dired-exec-file)
  )
