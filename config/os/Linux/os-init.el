(put 'Linux 'rcsid 
 "$Id: os-init.el,v 1.1 2000-10-30 19:08:04 cvs Exp $")

(message "Linux")

; overloads 

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"

t)
