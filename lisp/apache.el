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





