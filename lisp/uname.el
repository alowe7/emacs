(defconst rcs-id "$Id: uname.el,v 1.2 2000-07-30 21:07:48 andy Exp $")
(require 'eval-process)

;; misc stuff that uses eval process

(defun unix-version ()
  "return unix version as a string"
  (let ((s (clean-string (eval-process "uname"  "-r")))) 
    (and
     (string-match "\\." s)
     (substring s 0 (match-beginning 0)))))


(defun uname ()
  "return os"
  (interactive)
  (clean-string (eval-process "uname"  "-s"))
  )

(defun hostname ()
  (interactive)
  (message (clean-string (eval-process "hostname")))
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

