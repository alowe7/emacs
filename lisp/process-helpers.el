(put 'process-helpers 'rcsid "$Id: process-helpers.el,v 1.2 2000-10-03 16:44:07 cvs Exp $")


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

