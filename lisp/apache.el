(put 'apache 'rcsid "$Id: apache.el,v 1.4 2000-10-03 16:44:06 cvs Exp $")
(provide 'apache)
; (perl-command "wf")

(defun fwf (fn)
  (interactive "sFilename: ")
  (car (split (perl-command "wf" fn) "
"))
  )

(defun wf (fn)
  (interactive "sFilename: ")
  (let ((f (fwf fn)))
    (if f 
	(find-file f)
      (message "%s not found" f))
    )
  )





