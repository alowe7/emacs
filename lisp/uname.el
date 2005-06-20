(put 'uname 'rcsid 
 "$Id: uname.el,v 1.8 2005-06-20 17:28:42 cvs Exp $")
(require 'eval-process)

;; misc stuff that uses eval process

(defun unix-version ()
  "return unix version as a string"
  (let ((s (clean-string (eval-process "uname"  "-r")))) 
    (and
     (string-match "\\." s)
     (substring s 0 (match-beginning 0)))))

(defvar uname-equivalence-map nil
  "for the purposes of uname, these system names are equivalent"
  )

(defun uname (&optional arg)
  "return os"
  (interactive "sargs: ")
  (let* ((uarg (or arg "-s"))
	 (s (clean-string (eval-process "uname"  uarg)))
	 (u (or (cdr (assoc s uname-equivalence-map)) s)))
    (if (interactive-p) (message u) u))
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
   (t ; (eq window-system 'w32)
    (hostname))
   )
  )

(provide 'uname)
(provide 'hostname)
