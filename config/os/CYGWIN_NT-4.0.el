(put 'CYGWIN_NT-4.0 'rcsid
 "$Id: CYGWIN_NT-4.0.el,v 1.1 2002-12-02 03:12:31 cvs Exp $")

;; config file for gnuwin-1.0
(autoload 'shell2 "shell2" t)

(setq binary-process-input t
			explicit-shell-file-name "bash"
			shell-command-switch "-c"
			)

; this treats all files on z:\\foo as binary
;(add-untranslated-filesystem "Z:")

;this undoes that
; remove-untranslated-filesystem

; work-around annoyingly long timeouts

(defun host-exists (host &optional timeout)
  "returns t if HOST responds to a ping within optional TIMEOUT (default 200ms)"
  (let* ((stimeout (cond ((integerp timeout) (format "%s" timeout))
			 ((string* timeout "200"))))
	 (ps
	  (eval-process 
	   (expand-file-name
	    (format "%s/system32/ping.exe" 
		    (getenv "systemroot")))
	   "-w" stimeout "-n" "1" host)))
    (not (string-match "Request timed out." ps)))
  )

; e.g.
; (host-exists "simon") ; t if deadite is up
; (host-exists "10.132.10.1") ; nil
; (host-exists "deadite" 2)

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"


  (let ((host (and (> (length filename) 1)
		   (string-match "//\\([a-zA-Z0-9\.]+\\)/" filename)
		   (= (match-beginning 0) 0)
		   (substring filename (match-beginning 1) (match-end 1) ))))
    (or (not host)
	(host-exists host timeout)
	(and (not noerror)
	     (signal 'file-error (list "host not found" host))))
    )
  )

;; (host-ok "//simon/e")
;; (host-ok "//deadite/C" t)
;; (host-ok "c:/")

(load "w32" t)