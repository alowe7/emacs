(put 'xa 'rcsid
 "$Id: xa.el,v 1.5 2005-02-23 00:44:42 cvs Exp $")

(define-derived-mode xa-mode fundamental-mode "xa" "")

(defun xa (&optional prompt initial-input buffer cancel-message)
  "switch to a temp buffer to edit an entry.
giving optional PROMPT
return the bufferstring"

  (condition-case v
      (let ((b (or buffer (get-buffer-create "*edit new entry*"))) 
	    s)
	(save-excursion
	  (if (catch 'done
		(switch-to-buffer b)
		(xa-mode)
		(if prompt (setq mode-line-buffer-identification prompt))
		(if initial-input (progn (insert initial-input) (beginning-of-buffer)))
		(local-set-key "" '(lambda () (interactive)
					 (setq s (buffer-string))
					 (throw 'done nil)))
		(local-set-key "" '(lambda () (interactive) (y-or-n-p "are you sure? ") (throw 'done  t)))
		(setq fill-column (max (- (frame-width) 15) 70))
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