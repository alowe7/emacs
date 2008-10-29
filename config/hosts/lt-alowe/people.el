(put 'people 'rcsid
 "$Id: people.el,v 1.2 2008-10-29 01:01:44 alowe Exp $")
(require 'eval-utils)

(chain-parent-file t)



; this just needs to be more context sensitive...
(defvar *ows-contact-file* (expand-file-name "~/n/overwatch-phone.csv"))

; what's the best way to lazy eval on first use?
; (defvar *dscm-database* 
(setq *dscm-database* (split (read-file  *ows-contact-file* t) "\n"))

(defun find-person (name &optional db)
  " search `*dscm-database*' for regexp NAME
    if optional DB is specified, search it.

	runs find-person-hook after search
"
  (interactive "swho? ")

  (let* ((l (loop for x in  *dscm-database*  when (string-match name x) collect x))
	 (n (length l))
	 )

    (cond ((zerop n) (message "no matches"))
	  ((= n 1) (message (car l)))
	  (t
	   (let ((b (zap-buffer "*people*" 'people-mode)))
	     (loop for x in l do (insert x "\n"))

	     ;; if result is one-line & buffer isn't already showing in a window, 
	     ;; then message it.  otherwise, just display in buffer
	     (let ((n (count-lines (point-min) (point-max))))

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

