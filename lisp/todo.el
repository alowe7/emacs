(put 'todo 'rcsid 
 "$Id: todo.el,v 1.12 2005-02-11 23:46:04 cvs Exp $")
(require 'eval-process)
(require 'input)

(defvar master-todo-file (expand-file-name "~/.todo" ) 
  "location of master todo list")
(defvar master-todone-file (expand-file-name "~/.todone" ) 
  "location of master todone list")

(defun vtd ()
  " suck todone file into an edit buffer"
  (interactive)
  (find-file master-todone-file)
  (end-of-buffer)
  )

(defun vt ()
  " suck todo file into an edit buffer"
  (interactive)
  (find-file master-todo-file)
  (end-of-buffer)
  )


(defvar add-todo-date nil " if set, a date is prepended to todo entry")
(defvar add-todone-date t " if set, a date is prepended to todone entry")


(defun todone-file-name ()
  (expand-file-name (concat (file-name-directory (buffer-file-name)) ".done"))
  )

(defun notdone-file-name ()
  (expand-file-name (concat (file-name-directory (buffer-file-name)) ".notdone"))
  )

(defun todo (com &optional b)
  "make a line to master-todo-file"
  (interactive "scomment: ")
  (save-excursion
		(find-file (or b master-todo-file))
		(end-of-buffer)
    (insert (concat (if add-todo-date (shortdate) "") " " com "
"))
    (save-buffer)
    )
  )

(defun fudge-format (format stuff)
  "just apply FORMAT to list STUFF, but quote any % characters in elements of stuff"
  (apply 'format (nconc (list format) (mapcar '(lambda (x) (replace-in-string "%" "%%" x)) stuff)))
  )

(defun done (&optional arg)
  " move todo under point to per-world done list with prefix ARG, move region"
  (interactive "P")

  ; assert in todo buffer, looking at line containing subject item
  
  (let* ((trimlen1 (/ (frame-width) 5))
	 (trimlen2 (- (1+ (/ trimlen1 2))))
	 (thing1 (chomp (if (not arg) (apply 'buffer-substring (line-as-region))
			  (if (not (mark)) (error "mark is not set")
			    (buffer-substring (point) (mark))))))
	 (result (y-or-n-*-p
		  (fudge-format
			  "done with \"%s ... %s\" (y/n/e)? "
			  (if (> (length thing1) trimlen1)
			      (list (substring thing1 0 trimlen1)
				    (substring thing1 trimlen2))
			    (list thing1 "")))
		  "e"))
	 (thing (cond ((eq result ?e) (xa "edit thing" thing1))
		      (result thing1))))

    (if thing
	(progn
	  (write-region 
	   (format "%s	%s\n" (current-time-string) thing)
	   nil (todone-file-name) t)
	  (if (not arg)
	      (let ((kill-whole-line t))
		(beginning-of-line)
		(kill-line)
		)
	    (kill-region (point) (mark))
	    )
  ; assert still in todo buffer
	  (backup-file (buffer-file-name))
	  (basic-save-buffer)

  ; if a window happens to be showing the done file, update it
	  (loop for x being the windows
		when (string= 
		      (todone-file-name)
		      (buffer-file-name
		       (window-buffer x)))
		do (progn (set-buffer (window-buffer x)) (recenter)))

	  (if (looking-at "^$") (kill-line)) ; normal usage leaves an extra blank line.  kill it.
	  )
      (message "not done.")
      )
    )
  )


(defvar *notdone-record-separator* "----------------------------------
")

(defun notdone (&optional arg)
  " move todo under point to per-world done list with prefix ARG, move region"
  (interactive "P")

  ; assert in todo buffer, looking at line containing subject item
  
  (let* ((trimlen1 (/ (frame-width) 5))
	 (trimlen2 (- (1+ (/ trimlen1 2))))
	 (thing1 (chomp (if (not arg) (apply 'buffer-substring (line-as-region))
			  (if (not (mark)) (error "mark is not set")
			    (buffer-substring (point) (mark))))))
	 (result (y-or-n-*-p
		  (apply 'format
			 (cons "not done with \"%s ... %s\" (y/n/e)? "
			       (if (> (length thing1) trimlen1)
				   (list (substring thing1 0 trimlen1)
					 (substring thing1 trimlen2))
				 (list thing1 ""))))
		  "e"))
	 (thing (cond ((eq result ?e) (xa "edit thing" thing1))
		      (result thing1))))

    (if thing
	(progn
	  (write-region 
	   (format "%s%s\n" *notdone-record-separator* thing)
	   nil (notdone-file-name) t)
	  (if (not arg)
	      (let ((kill-whole-line t))
		(beginning-of-line)
		(kill-line)
		)
	    (kill-region (point) (mark))
	    )
  ; assert still in todo buffer
	  (backup-file (buffer-file-name))
	  (basic-save-buffer)

  ; if a window happens to be showing the done file, update it
	  (loop for x being the windows
		when (string= 
		      (notdone-file-name)
		      (buffer-file-name
		       (window-buffer x)))
		do (progn (set-buffer (window-buffer x)) (recenter)))

	  )
      (message "not done.")
      )
    )
  )



(run-hooks 'todo-when-loaded-hook)