(defconst rcs-id "$Id: apache.el,v 1.3 2000-07-30 21:07:44 andy Exp $")
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





