(put 'Linux 'rcsid 
 "$Id: os-init.el,v 1.3 2001-02-09 14:29:51 cvs Exp $")
(put 'os-init 'rcsid  'Linux)

(message "Linux")

; overloads 

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"
t)


(defvar *mount-list* '(("E:" "/simon/e") ("H:" "/simon/h")))

(defadvice find-file-noselect (around 
			       hook-find-file-noselect-smash
			       first activate)
  ""

  (if (and (not (file-exists-p (ad-get-arg 0)))
	   (string-match "^[A-Z]:" filename))

      (let* ((d (assoc (upcase (substring filename (match-beginning 0) (match-end 0)))
		       *mount-list*))
	     (f (concat (cadr d) (substring filename (match-end 0)))))
	(if (file-exists-p f) (ad-set-arg 0 f))
	)
    )
  ad-do-it

  )

; (ad-is-advised 'find-file-noselect)
; (ad-unadvise 'find-file-noselect)