(put 'other 'rcsid
 "$Id: other.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun dired-lastline (&optional p) 
  (cond ((< p (point-max))
	 (goto-char p))
	(t
	 (end-of-buffer)
	 (previous-line 1))
    )
  )

(defun cfo () (interactive)
; todo: if target exists, rename to backup 
  (let* ((p (point))
	 (from (dired-get-filename))
	 (fn (file-name-nondirectory from))
	 (dir (save-window-excursion 
		(other-window-1)
		default-directory))
	 (to (expand-file-name fn dir)))
    (copy-file from to t t)
    (save-window-excursion 
      (other-window-1)
      (revert-buffer)
  ; (search-forward fn)
      )
    (dired-lastline p)
    )
  )

(fset 'copy-file-other-window 'cfo)


(defun rfo () (interactive)
 
  (let* ((p (point))
	 (from (dired-get-filename))
	 (fn (file-name-nondirectory from))
	 (dir (save-window-excursion 
		(other-window-1)
		default-directory))
	 (to (expand-file-name fn dir)))
    (rename-file from to t)
    (dired-next-line 1)
    (setq x (point))
    (revert-buffer)
    (other-window-1)
    (dired-next-line 1)
    (setq y (point))
    (revert-buffer)
    (goto-char y)
    (other-window-1)
    (goto-char x)
  ; (search-forward fn)
    (dired-lastline p)
    )
  )

(fset 'move-file-other-window 'rfo)


(defun cfa () (interactive)
  (dired-copy-marked-files
   (save-window-excursion 
     (other-window-1)
     default-directory))
    (save-window-excursion 
      (other-window-1)
      (revert-buffer))
  (message "")
  )

(fset 'dired-copy-marked-files-other-window  'cfa)

