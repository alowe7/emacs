(put 'process-helpers 'rcsid 
 "$Id$")


(defun buffer-process (&optional ib)
  "return process associated with BUFFER, if any.
   default to current buffer."
  (interactive "b")
  (let* ((b (cond ((and (stringp ib) (> (length ib) 0)) (get-buffer ib))
		  (t (current-buffer))))
	 (v (catch 'found
	      (mapcar (function (lambda (x) (if (eq (process-buffer x) b) (throw 'found x)))) (process-list)))))
    (and (atom v) v )
    )
  )

;; zap a hung process from its buffer
(global-set-key (vector '\C-pause) 
		(function (lambda ()
		   (interactive)
		   (let ((p (buffer-process)))
		     (and 
		      (y-or-n-p (format "really kill process %s " (process-name p)))
		      (kill-process p)))))
		)
