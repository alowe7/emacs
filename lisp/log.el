

;;; log functions .  more generally useful 
(provide 'log)

(defvar master-log-file (concat (getenv "WBASE") "/log"))
;; (defvar *billdir* (getenv "WBILLDIR") "directory containing bill records")
;; (defvar *billlog* (getenv "WBILLLOG") "current bill record")

(defvar logview-hook 'logview-mode "hook run when viewing master log file")
(autoload 'logview-mode "logview-mode" nil t)

;; bug: if a log process is still active, it may not have taken effect yet.
(defun vl (&optional arg)
  "suck log file into an edit buffer.  
if one already exists, sync it up with the version on disk."
  (interactive "P")
  (let* ((f (if arg (read-file-name (format "view log file: ") ($ "$WBASE"))
	      master-log-file))
	 (b (or (get-file-buffer f)
		(find-file-noselect f t)))
	 (w (get-buffer-window b)))
    (or w (pop-to-buffer b))
    (select-window (get-buffer-window b))
    (set-buffer b)
    (or (verify-visited-file-modtime b) 
	(revert-buffer t t)) ; make sure it matches the version on disk
    (end-of-buffer)
    )
  (run-hooks 'logview-hook)
  )

(defun vb ()
  "view current bill record for this week"
  (interactive)
  (let* ((b (get-file-buffer *billlog*))
	 (w (and b (get-buffer-window b)))
	 (buf (or b
		  (find-file-noselect *billlog* t))))
    (if w (select-window w)
      (switch-to-buffer buf))
    ;; todo -- put in smarts to do this only if necessary.
    (revert-buffer t t)	; make sure it matches the version on disk
    (end-of-buffer)
    )
  )


(defun process-wait (p)
  "wait for process p to terminate"
  (while (and (processp p) (eq (process-status p) 'run))
    (sleep-for 1))
  )

(defvar *use-buffer-log* nil)

(defun log (com) (interactive "scomment:")
  (log-entry com)
  )

(defun* munge-time (&key d h m s ts)
  "produce a time string replacing with optional keyword arguments as follows:
	:d <day of month>
	:h <hour>
	:m <minute>
	:s <second>
	:ts <time string>

if :t is specified, use as basis for time string.
default is the current time string.

for example, if (current-time-string) is 
	Mon Jun 14 14:33:59 1999
then 
	(munge-time :h 1 :m 2)
produces
	Mon Jun 14 01:02:02 1999
"
(debug)
  (let 
      ((l (decode-time (if ts 
			   (current-time)))))

    (if d (rplaca (nthcdr 3 l) d))
    (if h (rplaca (nthcdr 2 l) h))
    (if m (rplaca (nthcdr 1 l) m))
    (if s (rplaca (nthcdr 0 l) s))

    (format-time-string "%a %b %d %T %Y"
			(apply 'encode-time l )
			))
  )

(defun log-entry (&rest args)
  "enter ARGS into master log file.  first
arg is a format string, remaining args are inputs for the format,
if necessary"

  (write-region
   (apply 'format
	  (nconc (list
		  (concat "%s\t%s\t%s\t" (car args) "\n")
		  (chop (eval-process "mktime" (current-time-string)))
		  (current-time-string)
		  (current-world))
		 (cdr args)))
   nil
   master-log-file
   t
   0
   )

  (let ((b (find-buffer-visiting master-log-file)) p)
    (if b
	(save-excursion
	  (if (buffer-modified-p b) 
	      (message "buffer %s modified" master-log-file)
	    (set-buffer b)
	    (setq p (point))
	    (revert-buffer nil t)
	    (goto-char p))))
    )
  )

(defun log-in (&optional c)
  " first thing to do practically every day"
  (interactive "P")
  (let* ((b (get-file-buffer master-log-file))
	 (w (and b (get-buffer-window b)))
	 (com (if (and c (stringp c)) c (and c (read-string "comment: "))))
	 )
    (log-entry "in %s" (or com ""))
    (if w (vl))
    )
  )

(run-hooks 'log-load-hook)
