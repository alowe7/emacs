(defconst rcs-id "$Id: process-helpers.el,v 1.1 2000-08-07 15:59:32 cvs Exp $")


(defun buffer-process (&optional ib)
  "return process associated with BUFFER, if any.
   default to current buffer."
  (interactive "b")
  (let* ((b (cond ((and (stringp ib) (> (length ib) 0)) (get-buffer ib))
		  (t (current-buffer))))
	 (v (catch 'found
	      (mapcar '(lambda (x) (if (eq (process-buffer x) b) (throw 'found x))) (process-list)))))
    (and (atom v) v )
    )
  )

