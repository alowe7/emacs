(put 'apache 'rcsid 
 "$Id: apache.el,v 1.6 2002-11-22 17:02:12 cvs Exp $")
(provide 'apache)
; (perl-command "wf")

(defun fwf (fn)
  (interactive "sFilename: ")
  (car (split (perl-command "wf" fn) "
"))
  )






