(put 'todo 'rcsid 
 "$Id: todo.el,v 1.5 2001-10-10 16:47:14 cvs Exp $")
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

(defun todone (p1 p2)
  "move region to `master-todone-file'"

  (interactive "r")

  (let ((trimlen 20)
	(thing (buffer-substring p1 p2)))

    (if (y-or-n-p
	 (apply 'format
		(cons "done with \"%s...%s\"? "
		      (if (> (length thing) trimlen)
			  (list (substring thing 0 trimlen)
				(substring thing -1))
			(list thing nil)))))
	(progn 
	  (write-region 
	   (format "%s %s" (current-time-string) thing)
	   nil master-todone-file t)
	  (kill-region p1 p2)
	  )
      (message "not done.")
      )
    )
  )



(run-hooks 'todo-when-loaded-hook)