(put 'checkpoint 'rcsid
 "$Id: checkpoint.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun checkpoint () 
  "insert `user-login-name' `current-time-string' at point in current buffer"
  (interactive)
  (insert (user-login-name) " " (current-time-string))
  )

(define-key (key-binding "\C-c\C-x") "" 'checkpoint)
