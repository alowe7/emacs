(put 'checkpoint 'rcsid
 "$Id$")

(defun checkpoint () 
  "insert `user-login-name' `current-time-string' at point in current buffer"
  (interactive)
  (insert (user-login-name) " " (current-time-string))
  )

(define-key (key-binding "\C-c\C-x") "" 'checkpoint)
