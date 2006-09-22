(put 'other 'rcsid
 "$Id: other.el,v 1.5 2006-09-22 20:01:51 alowe Exp $")

(defun other-lastline (&optional p) 
  (cond ((< p (point-max))
	 (goto-char p))
	(t
	 (end-of-buffer)
	 (previous-line 1))
    )
  )

(defun other-get-filename ()
  (funcall 
   (cond ((eq major-mode 'dired-mode) 'dired-get-filename)
	  ((eq major-mode 'fb-mode) 'fb-indicated-file)
	  (t 'indicated-filename))
   )
  )

(defun other-next-line (arg)
  (interactive "p")
  (funcall 
   (cond ((eq major-mode 'dired-mode) 'dired-next-line)
	  (t 'next-line))
   arg)
  )

(defun other-revert-buffer ()
  (cond ((eq major-mode 'dired-mode) (revert-buffer))
	)
  )

(defvar *wide-screen* 1280 "if `display-pixel-width` is greater than this, assume you have two monitors")

(defun other-zero () 
" find the zero coordinate of the other screen, if there is one.  tolerates multiple monitors"
  (if (and (> (display-pixel-width) *wide-screen*)
  ; its a wide-screen
	   (not (> (frame-parameter nil 'left)  *wide-screen*) ))
  ; currently on screen 1; zero is on screen 2
      (1+ *wide-screen*)
    0
    )
  )
; (other-zero)

(defun other-width () 
  (let ((w (display-pixel-width)))
    (if (> w *wide-screen*)
	(/ w 2)
      w)
    )
  )
; (other-width)

(defun rfo () (interactive)
 
  (let* ((p (point))
	 (from (other-get-filename))
	 (fn (file-name-nondirectory from))
	 (dir (save-window-excursion 
		(other-window-1)
		default-directory))
	 (to (expand-file-name fn dir)))
    (rename-file from to t)
    (other-next-line 1)
    (setq x (point))
    (other-revert-buffer)
    (other-window-1)
;    (read-string (format "1 %s: " (buffer-name)))
    (other-next-line 1)
    (setq y (point))
    (other-revert-buffer)
    (goto-char y)
    (other-window-1)
;    (read-string (format "2 %s: " (buffer-name)))
    (goto-char x)
;    (search-forward fn)
    (other-lastline p)
    )
  )

(fset 'move-file-other-window 'rfo)

(defun cfo () (interactive)
  ; todo: if target exists, rename to backup 
  (let* ((p (point))
	 (from (other-get-filename))
	 (fn (file-name-nondirectory from))
	 (dir (save-window-excursion 
		(other-window-1)
		default-directory))
	 (to (expand-file-name fn dir)))

    (cond
     ((and (file-directory-p from) 
	   (file-directory-p to))
      (error (format "tbd -- would clobber directory %s" to)))
     ((file-directory-p from) 
      (shell-command (format "cp -r %s %s" from dir))
      )
     (t
      (copy-file from to t t)
      ))

    (save-window-excursion 
      (other-window-1)
      (other-revert-buffer)
  ; (search-forward fn)
      )
    (other-lastline p)
    )
  )

(fset 'copy-file-other-window 'cfo)

(defun cfa () (interactive)
  (dired-copy-marked-files
   (save-window-excursion 
     (other-window-1)
     default-directory))
    (save-window-excursion 
      (other-window-1)
      (other-revert-buffer))
  (message "")
  )

(fset 'dired-copy-marked-files-other-window  'cfa)

(provide 'other)