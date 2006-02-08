;; xxx wet paint
;; xxx fsf emacs/xemacs portability
(cond ((and (boundp 'running-xemacs) running-xemacs)
       (defun whack-key-sequence (x)
	 (cadr (assoc 
		(cadr (member 'key (event-properties  (aref x 0))))
 		'((backspace ?))))
	 )
       (fset 'read-key-p '(lambda ()  
			    (let ((k (read-key-sequence "")))
			      (or last-input-char
				  (whack-key-sequence k))))))
      (t
       (fset 'read-key-p 'read-char))
      )

;(read-key-p)
