(put 'todo 'rcsid 
 "$Id: todo.el,v 1.6 2003-05-25 20:55:11 cvs Exp $")
(require 'eval-process)

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


(defun todone-file-name () (expand-file-name (concat (file-name-directory (buffer-file-name)) ".done")))

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

(defun done (&optional arg)
  " move todo under point to per-world done list with prefix ARG, move region"
  (interactive "P")

  ; assert in todo buffer, looking at line containing subject item
  
  (let* ((trimlen1 (/ (frame-width) 5))
	 (trimlen2 (- (1+ (/ trimlen1 2))))
	 (thing (chomp (if (not arg) (apply 'buffer-substring (line-as-region))
			 (if (not (mark)) (error "mark is not set")
			   (buffer-substring (point) (mark)))))))

    (if (y-or-n-p
	 (apply 'format
		(cons "done with \"%s ... %s\"? "
		      (if (> (length thing) trimlen1)
			  (list (substring thing 0 trimlen1)
				(substring thing trimlen2))
			(list thing "")))))
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
	  )
      (message "not done.")
      )
    )
  )



(run-hooks 'todo-when-loaded-hook)