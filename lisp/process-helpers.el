(put 'process-helpers 'rcsid 
 "$Id: process-helpers.el,v 1.4 2001-08-28 22:11:39 cvs Exp $")


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

;; zap a hung process from its buffer
(global-set-key (vector '\C-pause) 
		'(lambda ()
		   (interactive)
		   (let ((p (buffer-process)))
		     (and 
		      (y-or-n-p (format "really kill process %s " (process-name p)))
		      (kill-process p))))
		)
