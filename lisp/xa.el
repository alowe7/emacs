(put 'xa 'rcsid
 "$Id: xa.el,v 1.2 2003-10-24 13:30:31 cvs Exp $")

(defun xa (&optional prompt initial-input buffer cancel-message)
  "switch to a temp buffer to edit an entry.
giving optional PROMPT
return the bufferstring"

  (condition-case v
      (let (s b)
	(save-excursion
	  (if (catch 'done
		(setq b (switch-to-buffer (or buffer (get-buffer-create "*j*"))))
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
	(kill-buffer b)
	(xdb-cleanup s))
    (error nil)
    )
  )

(provide 'xa)