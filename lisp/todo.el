(require 'eval-process)

(defvar master-todo-file (expand-file-name "~/todo" ) 
  "location of master todo list")
(defvar master-todone-file (expand-file-name "~/todone" ) 
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

;; does this really belong here.
(defun shortdate ()
  "report a brief date sans time"
  (interactive)
  (let ((d (if (and display-time-process
	   (eq (process-status display-time-process) 'run))
      (let ((s (current-time-string)))
	(format "%s %s %s" (substring s 0 10) (substring s 22) (substring s 11 16)))
    (clean-string (eval-process "shortdate"))
    )))
    (if (interactive-p) (message d) d))
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

(defun todone (arg)
  "mark todo entry as done.  
   should be on a line in master-todo-file.
   with prefix arg, takes current line & arg subsequent
"
  (interactive "*p")
  (if (not (string= (buffer-file-name) master-todo-file))
      (message "not visiting todo file.  try vt.")
    (save-excursion
      (let* ((p (progn (beginning-of-line) (point)))
	     (s (buffer-substring p (progn (next-line (or arg 1)) (beginning-of-line) (point)))))
      	(kill-region p (point))
	(vtd)
	(if add-todone-date (insert (format "%s " (shortdate))))
	(insert s)
	))))


;; todo tickle from region a/o buffer
(defun tickle (subject message time)
  "send a reminder to myself at the specified time.
	args are mail SUBJECT, MESSAGE and TIME.
	format for time is like the at(1) command:
	for example, 
	  3:00  pm  January  24
	  3  pm  Jan  24
	  1500  jan  24
"
  (interactive "ssubject: \nsmessage: \nstime: ")
  (let ((z (zap-buffer "*tickle*"))
	(cmd (format "tickle  \"%s\" \"%s\" \"%s\"" subject time message)))

    (call-process shell-file-name nil t nil "-c" cmd)
    (message (clean-string (buffer-substring (point-min) (point-max))))
    (kill-buffer z)
    )
  )

(run-hooks 'todo-when-loaded-hook)