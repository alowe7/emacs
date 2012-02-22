(put 'log-helper 'rcsid 
 "$Id$")
(defun log-timeval (&optional s)

	;; this save-excursion should probably be in eval-process
	(save-excursion
		(clean-string (eval-process "mktime" (bgets))))
	)

(defun next-log-entry () (interactive) 
	"assume in two-window mode looking at two log files put point on a log
entry, moves point in other-window to next log entry not less than
current time "

	(let ((a (log-timeval)))
		(other-window 1) 
		(while 
				(and (string< (log-timeval) a) (not (eobp)))
			(forward-line 1))
		(other-window 1) 
		)
	)

(define-key logview-mode-map "" 'next-log-entry)
(define-key logview-mode-map "" 
	'(lambda nil (interactive)
		 (forward-word 1)
		 (other-window 1)
		 (forward-word 1)
		 (other-window 1)))






