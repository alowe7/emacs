(put 'post-people 'rcsid
 "$Id$")

(require 'directories)

; this just needs to be more context sensitive...
(defvar *ows-contact-directory* "/work/overwatch/people")
(defvar *ows-contact-file-regexp*  "overwatch-phone-list-[0-9]*\.csv$")

; this takes the most current file matching the 
(defvar *ows-contact-file* (expand-file-name
			    (car (sort
				  (get-directory-files *ows-contact-directory* t *ows-contact-file-regexp*)
				  (lambda (x y) (compare-filetime x y))
				  )))
  )

; what's the best way to lazy eval on first use?
(defvar *dscm-database* nil)

(defun initialize-dscm-database (&optional force)
  (unless (file-exists-p *ows-contact-file*)
    (error "error setting *dscm-database*, %s does not exist" *ows-contact-file*))
  (setq *dscm-database* (splitf (read-file  *ows-contact-file* t)))
  (put '*dscm-database* 'last-modified-time (filemodtime *ows-contact-file*))
  *dscm-database*
  )
; (initialize-dscm-database)

(defun dscm-database () 
  ; (format-time-string "%c" (filemodtime *ows-contact-file*))
  (let ((last-modified-time (and *dscm-database* (get '*dscm-database* 'last-modified-time))))
    (when
	(or (null last-modified-time) ; not initialized 
	    (< (compare-filetime last-modified-time (filemodtime *ows-contact-file*)) 0) ; file newer than last refresh
	    )
      (initialize-dscm-database))
    *dscm-database*
    )
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

(setq *minibuffer-display-unique-hit* t)
