(put 'people 'rcsid
 "$Id$")

(chain-parent-file t)

; this just needs to be more context sensitive...
(defvar *ows-contact-file* (expand-file-name "/work/overwatch/people/overwatch-phone-list-101007.csv"))

; what's the best way to lazy eval on first use?
(defvar *dscm-database* nil)

(defun initialize-dscm-database ()
  (unless (file-exists-p *ows-contact-file*)
    (error "error setting *dscm-database*, %s does not exist" *ows-contact-file*))
  (setq *dscm-database* (split (read-file  *ows-contact-file* t) "\n"))
  )

(defun dscm-database () 
  (or *dscm-database* (initialize-dscm-database))
  )
; (dscm-database)

(defun find-person (name &optional db)
  " search `*dscm-database*' for regexp NAME
    if optional DB is specified, search it.

	runs find-person-hook after search
"
  (interactive "swho? ")

  (let* ((l (loop for x in (dscm-database)  when (string-match name x) collect x))
	 (n (length l))
	 )

    (cond 
     ((zerop n) (message "no matches"))
; singleton hit and target buffer is not already showing
     ((and (= n 1)
	   (not (let ((b (get-buffer "*people*"))) (and (buffer-live-p b) (get-buffer-window-list b)))))
      (message (kill-new (car l))))
     (t
      (let ((b (zap-buffer "*people*" 'people-mode)))
	(loop for x in l do (insert x "\n"))

	;; if result is one-line & buffer isn't already showing in a window, 
	;; then message it.  otherwise, just display in buffer
	(let ((n (count-lines (point-min) (point-max))))

	  (goto-char (point-min))
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only t)
	  (let ((w (get-buffer-window b)))
	    (if w (select-window w)
	      (switch-to-buffer b)))
	  )
	)
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
		 (dscm-database)))
  ; see /content/personal/people.sql for the schema
	 (sql (format "insert into people (name, extension) values ('%s', '%s')" name extension))
	 (retval (perl-command-1 "txodbc" :args (list "-n" (dscm-database) sql)))
	 (b (zap-buffer "*people*" 'people-mode)))

    (message retval)

    )
  )

