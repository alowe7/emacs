(put 'xa 'rcsid
 "$Id: xa.el,v 1.3 2004-07-21 20:18:21 cvs Exp $")

(defun xa (&optional prompt initial-input buffer cancel-message)
  "switch to a temp buffer to edit an entry.
giving optional PROMPT
return the bufferstring"

  (condition-case v
      (let ((b (or buffer (get-buffer-create "*j*"))) 
	    s)
	(save-excursion
	  (if (catch 'done
		(switch-to-buffer b)
		(if prompt (setq mode-line-buffer-identification prompt))
		(if initial-input (progn (insert initial-input) (beginning-of-buffer)))
		(local-set-key "" '(lambda () (interactive)
					 (setq s (buffer-string))
					 (throw 'done nil)))
		(local-set-key "" '(lambda () (interactive) (y-or-n-p "are you sure? ") (throw 'done  t)))
		(message "C-c C-c to exit	 C-c C-u to cancel")
		(sit-for 1)
		(recursive-edit))
	      (if cancel-message (progn 
				   (message "cancelled")
				   (sit-for 0 500)
				   (message "")))
	    ))
	(unless buffer (kill-buffer b)) ; kill b only if we created it
	s)
    (error nil)
    )
  )

(provide 'xa)