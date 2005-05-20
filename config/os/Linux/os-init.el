(put 'os-init 'rcsid
 "$Id: os-init.el,v 1.9 2005-05-20 20:25:15 cvs Exp $")

;; (read-string "Linux")

; overloads 

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"
t)


(setq comint-prompt-regexp "^[0-9]+[#%] *")

(require 'locate)


(global-set-key "r" 'rmail)

(require 'cat-utils)
(defun split-path (path)
  (split path ":")
  )

(defun canonify (f &optional mixed)
" on unix `identity' see `unix-canonify'."
  f
  )

(defvar file-name-buffer-file-type-alist nil "found in dos-w32, noop on linux")
