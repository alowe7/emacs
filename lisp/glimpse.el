(put 'glimpse 'rcsid 
 "$Id: glimpse.el,v 1.4 2000-10-03 16:50:28 cvs Exp $")
(require 'compile)

(defvar glimpse-mode-map nil)
(defvar glimpse-mode-map-1 nil)
(defvar glimpse-mode-map-2 nil)
(defvar *glimpsevec* nil)
(make-variable-buffer-local '*glimpsevec*)
(make-variable-buffer-local '*glimpsepat*)

(defun glimpse-goto-hit (&optional arg)
  (interactive "P")
  (let* ((l (split (bgets) ":"))
	 (fn (car l))
	 (ln (car (read-from-string (cadr l))))
	 (b (find-file-noselect fn)))
    (if arg (pop-to-buffer b)
      (switch-to-buffer b))
    (goto-line ln)
    )
  )
(defun glimpse-goto-hit-other-window ()
  (interactive)
  (glimpse-goto-hit t)
  )
(defun glimpse-hit-info ()
  (interactive)
  (let* ((l (split (bgets) ":"))
	 (fn (car l))
	 (ln (car (read-from-string (cadr l)))))
	 (message "%s:%d" fn ln)
    )
  )


(defun glimpse-mode ()
  (interactive)
  (use-local-map
   (or  glimpse-mode-map
	(prog1
	    (setq glimpse-mode-map
		  (copy-keymap compilation-mode-map))
	  (define-key glimpse-mode-map "\C-m" 'glimpse-goto-hit)
	  (define-key glimpse-mode-map "o" 'glimpse-goto-hit-other-window)
	  (define-key glimpse-mode-map "?" 'glimpse-hit-info)
	  ))

   )
  (wrap)
  (not-modified)
  )

(defun glimpse (pat)
  (interactive "sPat: ")
  (let ((b (zap-buffer "*glimpse*")))
    (call-process "glimpse" nil b nil "-n" pat)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (glimpse-mode)
    (setq *glimpsepat* pat)
    )
  )

(defun wglimpse (pat)
  (interactive "sPat: ")
  (let ((b (zap-buffer "*glimpse*")))
    (call-process "glimpse" nil b nil "-w" "-n" pat)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (glimpse-mode)
    (setq *glimpsepat* pat)
    )
  )

(defun clean-glimpse ()
  (interactive)
  ; assert: in glimpse-mode
  (let* ((s (buffer-string))
	 (vec 
	  (progn
	    (setq buffer-read-only nil)
	    (erase-buffer)
	    (apply 'vector 
		   (loop for x in (split s "
")
			 when (> (length x) 0)
			 collect 
			 (let ((h (split x ":")))
			   (insert (caddr h) "\n")
			   (list (car h) (car (read-from-string (cadr h))))))))))

    (setq *glimpsevec* vec)
    (beginning-of-buffer)
    (glimpse-mode)
    (use-local-map
     (or  glimpse-mode-map-1
	  (prog1
	      (setq glimpse-mode-map-1
		    (copy-keymap compilation-mode-map))
	    (define-key glimpse-mode-map-1 "\C-m" 'glimpse-goto-hit-1)
	    (define-key glimpse-mode-map-1 "o" 'glimpse-goto-hit-other-window-1)
	    (define-key glimpse-mode-map-1 "?" 'glimpse-hit-info-1)
	    ))

     )
    (setq buffer-read-only t)
    (setq mode-line-buffer-identification *glimpsepat*)
    )
  )

(defun glimpse-goto-hit-1 (&optional arg)
  (interactive "P")
  (let* ((l (aref *glimpsevec* (count-lines (point-min) (point))))
	 (fn (car l))
	 (ln (cadr l))
	 (b (find-file-noselect fn)))
    (if arg (pop-to-buffer b)
      (switch-to-buffer b))
    (goto-line ln)
    )
  )
(defun glimpse-goto-hit-other-window-1 ()
  (interactive)
  (glimpse-goto-hit-1 t)
  )
(defun glimpse-hit-info-1 ()
  (interactive)
  (let* ((l (aref *glimpsevec* (count-lines (point-min) (point))))
	 (fn (car l))
	 (ln (cadr l)))
	 (message "%s:%d" fn ln)
    )
  )

(defun glimpse-mode-2 ()
  (glimpse-mode)
  (use-local-map
   (or  glimpse-mode-map-2
	(prog1
	    (setq glimpse-mode-map-2
		  (copy-keymap compilation-mode-map))
	  (define-key glimpse-mode-map-2 "\C-m" 'glimpse-goto-hit-1)
	  (define-key glimpse-mode-map-2 "o" 'glimpse-goto-hit-other-window-1)
	  (define-key glimpse-mode-map-2 "?" 'glimpse-hit-info-1)
	  ))

   )
  )

(defun glimpse2 (pat)
  (interactive "sPat: ")
  (let ((b (zap-buffer "*glimpse*"))
	(vec (car (read-from-string (eval-process "eglimpse" pat)))))

    (set-buffer b)
    (loop for y across vec
	  do
	  (insert (caddr y)))
    (glimpse-mode-2)
    (wrap)
    (not-modified)
    (setq buffer-read-only t)
    (setq mode-line-buffer-identification pat)
    (pop-to-buffer b)
    (beginning-of-buffer)
    )
  )