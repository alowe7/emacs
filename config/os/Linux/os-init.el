(put 'Linux 'rcsid 
 "$Id: os-init.el,v 1.5 2002-02-21 05:05:44 cvs Exp $")
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

(defun aexec (f &optional visit)
  "apply command associated with filetype to specified FILE
filename may have spaces in it, so double-quote it.
handlers may be found from the variable `file-assoc-list' or 
failing that, via `file-association' 
if optional VISIT is non-nil and no file association can be found just visit file, otherwise
 display a message  "
  (interactive "sFile: ")
  (let* ((ext (file-name-extension f))
	 (handler (and ext (assoc (downcase ext) file-assoc-list))))
    (if handler (funcall (cdr handler) f)
      (message "handler not found"))
    )
  )

(defun linux-howto (what) (interactive "swhat: ")
  (let ((s (eval-process "locate" (format "HOWTO/%s" what)))
	(b (zap-buffer "*howto*")))
    (set-buffer b)
    (insert s)
    (fb-mode)
    (pop-to-buffer b)
    (beginning-of-buffer)
    ))
(global-set-key (vector 'kp-f1) 'linux-howto)