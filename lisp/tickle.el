(put 'tickle 'rcsid 
 "$Id: tickle.el,v 1.2 2000-10-03 16:50:29 cvs Exp $")

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
