(put 'people 'rcsid
 "$Id: people.el,v 1.1 2006-02-13 15:32:15 alowe Exp $")

(chain-parent-file t)

(setq *dscm-database* "dscm")

(defun find-person (name &optional db)
  " search `*dscm-database*' for regexp NAME
    if optional DB is specified, search it.

	runs find-person-hook after search
"
  (interactive "swho? ")
  (let* ((b (prog1 (zap-buffer "*people*") (people-mode)))
	 (tmpfilename (make-temp-file "note"))
	 (db (or db 
		 *dscm-database*))
	 (sql (format "select Employee, Ext from people where Employee like '%%%s%%'" name))
	 (retval (perl-command-1 "txodbc" :args (list "-n" *dscm-database* sql)))
	 n)

    (set-buffer b)
    (insert retval)

    ;; if result is one-line & buffer isn't already showing in a window, 
    ;; then message it.  otherwise, just display in buffer
    (setq n (count-lines (point-min) (point-max)))
    (unless (cond 
	     ((zerop n) ; if not found try harder
	      (message "not found"))
	   
	     ((and (not (get-buffer-window b))
		   (= 1 n)
		   *minibuffer-display-unique-hit*)
	      (progn
	      
		(message "%s" (clean-string (buffer-string)))
		(kill-buffer b)
		t)))
      (pop-to-buffer b)
      (beginning-of-buffer)
      (set-buffer-modified-p nil)
      (setq buffer-read-only t)
      )
    )
  )

; (find-person "george")
