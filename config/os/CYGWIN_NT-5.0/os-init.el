(put 'CYGWIN_NT-5.0 'rcsid 
 "$Id: os-init.el,v 1.12 2001-07-13 22:11:35 cvs Exp $")
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
		   (string-match "//\\([a-zA-Z0-9\.]+\\)" filename)
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

;; build a list of ((<regexp> <mountpoint>) ...)
;; later used for autosubstitution

;; maybe it would be better to comb the registry.
(cond ((string-match "1.3.2" (eval-process "uname" "-r"))

       ;; mount output format for (beta) release 1.3.2
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (split (eval-process "mount") "
")
		     collect 
		     (let ((l (split x " ")))
		       (list (caddr l) (car l))))
	       )
	 )
       )

      (t 
       ;; mount output format for release 1.0
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (cdr (split (eval-process "mount") "
"))
		     collect
		     (let
			 ((l (split (replace-in-string "[ ]+" " " x))))
		       (list (cadr l) (car l))))
	       )
	 )
       )
      )

(add-hook 'after-init-hook 'cygmounts)

(defadvice cd (around 
		     hook-cd
		     first activate)
  ""

  ; check cygmounts for drive changes

  (let* ((d (ad-get-arg 0))
	 (d1 (unless (string-match "^//" d)
	       (loop for x in cygmounts 
		   if (string-match (concat "^" (car x)) d)
		   return (replace-in-string (concat "^" (car x)) (cadr x) d)
		   )))
	 (d2 (and d1 (expand-file-name d1))))
    (and d2 (ad-set-arg 0 d2))
    ad-do-it
    )
  )

; (ad-is-advised 'cd)
; (ad-unadvise 'cd)

; xxx todo: catch shell command w <world> for shell-cd

(defadvice dired (around 
		  hook-dired
		  first activate)
  ""

  ; check cygmounts for drive changes
  
  (let* ((d (ad-get-arg 0))
	 (d1 (unless (string-match "^//" d)
	       (loop for x in cygmounts when 
		     (string-match (concat "^" (car x)) d)
		     return 
		     (replace-in-string (concat "^" (car x)) (cadr x) d)
		     )))
	 (d2 (and d1 (expand-file-name d1))))
    (and d2 (ad-set-arg 0 d2))
    ad-do-it
    )
  )

; (ad-is-advised 'dired)
; (ad-unadvise 'dired)


(defadvice find-file-noselect (around 
			       hook-find-file-noselect
			       first activate)
  ""

  ; check cygmounts for drive changes
  
  (let* ((d (ad-get-arg 0))
	 (d1 (unless (string-match "^//" d)
	       (loop for x in cygmounts when 
		     (string-match (concat "^" (car x)) d)
		     return 
		     (replace-in-string (concat "^" (car x)) (cadr x) d)
		     )))
	 (d2 (and d1 (expand-file-name d1))))
    (and d2 (ad-set-arg 0 d2))
    ad-do-it
    )
  )

; (ad-is-advised 'find-file-noselect)
; (ad-unadvise 'find-file-noselect)

(defun delete-all-other-frames ()
	(interactive)
	"delete all frames except the currently focused one."
	(dolist (a (frame-list))
		(if (not (eq a (selected-frame)))
				(delete-frame a))))

;; where does this really belong?
(defun ftime () (interactive)
	"display formatted time string last modification time of file for current buffer"
  (let* ((fn (buffer-file-name))
	(f (and fn (elt (file-attributes fn) 5))))
    (message (if f
	(clean-string (eval-process "mktime" (format "%d" (car f)) (format "%d" (cadr f))))
	"no file")
	)
    )
  )
