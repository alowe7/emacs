(put 'pre-debug 'rcsid "$Id: pre-debug.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
(or (boundp 'debug-function-list)
    (load-library "debug"))

(defun debug-indicated-word  (s)
  (interactive 
   (list (read-string (format "Debug on entry (%s): " (indicated-word "-")))))
  (if (< (length s) 1) (setq s (indicated-word "-")))
  (if (functionp (intern s))
      (funcall 'toggle-debug-on-entry  (intern s))
    (message "%s is not a function" s)))

(defun toggle-debug-on-entry (fn)
  (interactive "sToggle debug on entry: ")
  "toggles debug on entry"
  (if (and
       (boundp 'debug-function-list)
       (member fn debug-function-list))
      (progn
	(cancel-debug-on-entry fn)
	(message "debug on entry to %s canceled." fn))
    (progn (debug-on-entry fn) (message "debug on entry to %s." fn))
    ) 
  )
