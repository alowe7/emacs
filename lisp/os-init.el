(put 'os-init 'rcsid
 "$Id: os-init.el,v 1.1 2005-09-30 20:19:10 cvs Exp $")

; this is the default generic os-init
; specific platforms can override or extend using `chain-parent-file'

(defun copy-filename-as-kill (f) 
  "apply `kill-new' to FILENAME"
  (interactive "sfilename: ")
  (let ((s (or
  ; try a normal canonify.  if that errs, try a unc canonify
	    (condition-case x (canonify f 0) (error nil))
	    (unc-canonify f)
	    )))
    (kill-new s)
    s)
  )

(defun canonify (f &optional ignored)
  "default identity canonification"
  f)

(fset 'unc-canonify 'canonify)
(fset 'unix-canonify 'canonify)
(fset 'w32-canonify 'canonify)
