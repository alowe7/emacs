(put 'post-dired 'rcsid
 "$Id: post-dired.el,v 1.9 2009-11-15 02:12:23 alowe Exp $")

(chain-parent-file t)

; tbd promote these...

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




