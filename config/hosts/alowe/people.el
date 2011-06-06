(put 'people 'rcsid
 "$Id$")

(chain-parent-file t)

(setq *dscm-database* "dscm")

(defvar *people-sql* "select name + '|' +  extension +  '|', email from people3 where name like '%%%s%%' order by name" 
  "sql query to extract name, extension and email for people")

(defvar *contacts* (expand-file-name "~/n/people"))

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
	 (sql (format *people-sql* name))
	 (retval (perl-command-1 "txodbc" :args (list "-n" *dscm-database* sql)))
	 (b (zap-buffer "*people*" 'people-mode)))

    (loop for y in 
	  (loop for x in (split retval "\n") collect (split x "|"))
	  do
	  (insert (concat (car y) "\t" (cadr y) "\t" (caddr y) "\n"))
	  )

    ;; if result is one-line & buffer isn't already showing in a window, 
    ;; then message it.  otherwise, just display in buffer
    (let ((n (count-lines (point-min) (point-max))))

      (cond 
       ((zerop n) ; if not found try harder
	(shell-command (format "grep -i %s %s" name *contacts*) t)
	(setq n (count-lines (point-min) (point-max)))
	))
	   
       (unless (cond 
		((zerop n) ; if not found at this point, give up
		 (message "not found")
		 )
	   
		((and (not (get-buffer-window b))
		      (= 1 n)
		      *minibuffer-display-unique-hit*)
		 (progn
		   (message "%s" (kill-new (clean-string (buffer-string))))
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

(defun person-by-initials (initials)
 
  (let* ((sql "select name from people3")
	 (retval (perl-command-1 "txodbc" :args (list "-n" *dscm-database* sql)))
	 (firsti (and (> (length initials) 0)  (format "^%c" (aref initials 0))))
	 (lasti (and (> (length initials) 1) (format "^%c" (aref initials 1))))
	 )
    (loop for y in 
	  (loop for x in (split retval "
") collect 
(split (trim x) ", "))
	  when
	  (and (string-match lasti (car y)) (stringp (cadr y)) (string-match firsti (cadr y)))
	  collect (join (reverse y) " "))
    )
  )
; (person-by-initials "jr")

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

