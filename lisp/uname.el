(put 'uname 'rcsid 
 "$Id: uname.el,v 1.6 2003-05-15 21:00:02 cvs Exp $")
(require 'eval-process)

;; misc stuff that uses eval process

(defun unix-version ()
  "return unix version as a string"
  (let ((s (clean-string (eval-process "uname"  "-r")))) 
    (and
     (string-match "\\." s)
     (substring s 0 (match-beginning 0)))))


(defun uname (&optional arg)
  "return os"
  (interactive "sargs: ")
  (let* ((uarg (or arg "-s"))
	 (s (clean-string (eval-process "uname"  uarg))))
    (if (interactive-p) (message s) s))
  )

(defun hostname ()
  (interactive)
  (let ((s (clean-string (eval-process "hostname"))))
    (if (interactive-p) (message s) s))
  )

(defun displayhost ()
  (cond 
   ((eq window-system 'x)
    (let ((display (getenv "DISPLAY")))
      (if (and
	   display
	   (string-match  ":" display))
	  (substring display 0 (1- (match-end 0)))
	(hostname))))
   (t ; (eq window-system 'win32)
    (hostname))
   )
  )

(provide 'uname)
(provide 'hostname)
