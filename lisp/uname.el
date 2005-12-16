(put 'uname 'rcsid 
 "$Id: uname.el,v 1.10 2005-12-16 00:31:47 tombstone Exp $")
(require 'eval-process)
(require 'typesafe)

;; misc stuff that uses eval process

(defun unix-version ()
  "return unix version as a string"
  (let ((s (string* (clean-string (eval-process "uname"  "-r"))))) 
    (cond
     ((null s)
      ; try harder.
      (getenv "OS"))
     ((string-match "\\." s)
      (substring s 0 (match-beginning 0))))))

(defvar uname-equivalence-map nil
  "for the purposes of uname, these system names are equivalent"
  )

(defun uname (&optional arg)
  "return os"
  (interactive "sargs: ")
  (let* ((uarg (or arg "-s"))
	 (s (string* (clean-string (eval-process "uname"  uarg))))
	 (u 
	  (cond
	   ((null s)
  ; try harder.
	    (getenv "OS"))
	   (t (or (cdr (assoc s uname-equivalence-map)) s)))))
    (if (interactive-p) (message u) u))
  )

(defun hostname ()
"return hostname"
  (interactive)
  (let ((s 
		 (or 
		  (getenv "COMPUTERNAME") 
		  (getenv "HOSTNAME")
		  (clean-string (eval-process "hostname")))))
    (if (interactive-p) (message s) s))
  )

; (hostname)

(defun hostname-non-domain ()
  (interactive)
  (let* ((h (hostname))
		 (s (cond ((string-match "\\." h) 
				   (setq s (substring h 0 (match-beginning 0))))
				  (t h))))

    (if (interactive-p) (message s) s)
	)
  )

; (hostname-non-domain)

(defun displayhost ()
  (cond 
   ((eq window-system 'x)
    (let ((display (getenv "DISPLAY")))
      (if (and
	   display
	   (string-match  ":" display))
	  (substring display 0 (1- (match-end 0)))
	(hostname))))
   (t ; (eq window-system 'w32)
    (hostname))
   )
  )

(provide 'uname)
(provide 'hostname)
