(put 'CYGWIN_NT-5.0 'rcsid 
 "$Id: os-init.el,v 1.2 2001-02-09 14:29:51 cvs Exp $")
(put 'os-init 'rcsid 'CYGWIN_NT-5.0)

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

(defvar *short-timeout* 200 "time to wait for network drive to respond, in ms")

(defun host-exists (host &optional timeout)
  "returns t if HOST responds to a ping within optional TIMEOUT.
TIMEOUT may be an integer or a string representation of an integer.
 (default is `*short-timeout*`)"

  (let* ((stimeout (string* timeout
			    (format "%s" 
				    (if (integerp timeout) timeout
				      *short-timeout*))))
	 (ps
	  (eval-process 
	   (expand-file-name
	    (format "%s/system32/ping.exe" 
		    (getenv "systemroot")))
	   "-w" stimeout "-n" "1" host)))

    (not (or (loop for x in 
		   '("Request timed out"
		     "Destination host unreachable" 
		     "Unknown host")
		   thereis (string-match x ps))))
    )
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

