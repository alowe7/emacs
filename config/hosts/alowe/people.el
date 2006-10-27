(put 'people 'rcsid
 "$Id: people.el,v 1.5 2006-10-27 21:21:56 alowe Exp $")

(chain-parent-file t)

(setq *dscm-database* "dscm")

(defun find-person (name &optional db)
  " search `*dscm-database*' for regexp NAME
    if optional DB is specified, search it.

	runs find-person-hook after search
"
  (interactive "swho? ")
  (let* (
	 (db (or db 
		 *dscm-database*))
  ; see /content/personal/people.sql for the schema
	 (sql (format "select * from people where name like '%%%s%%' order by name" name))
	 (retval (perl-command-1 "txodbc" :args (list "-n" *dscm-database* sql)))
	 (b (zap-buffer "*people*" 'people-mode)))

    (insert retval)

    ;; if result is one-line & buffer isn't already showing in a window, 
    ;; then message it.  otherwise, just display in buffer
    (let ((n (count-lines (point-min) (point-max))))
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
	(beginning-of-buffer)
	(set-buffer-modified-p nil)
	(setq buffer-read-only t)
	(let ((w (get-buffer-window b)))
	  (if w (select-window w)
	    (switch-to-buffer b)))
	)
      )
    )
  )

; (find-person "george")

  (define-key people-mode-map "\C-m" 'find-person)
  (define-key  people-mode-map "?" 'find-person)


(defun add-person (name extension &optional db)
  " add NAME and EXTENSION to `*dscm-database*' 
    if optional DB is specified, search that instead.
"
  (interactive "sname: \nsextension: ")
  (let* (
	 (db (or db 
		 *dscm-database*))
  ; see /content/personal/people.sql for the schema
	 (sql (format "insert into people (name, extension) values ('%s', '%s')" name extension))
	 (retval (perl-command-1 "txodbc" :args (list "-n" *dscm-database* sql)))
	 (b (zap-buffer "*people*" 'people-mode)))

    (message retval)

    )
  )

