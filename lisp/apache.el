(put 'apache 'rcsid 
 "$Id: apache.el,v 1.7 2004-01-21 18:46:44 cvs Exp $")
(provide 'apache)
; (perl-command "wf")

(defun fwf (fn)
  (interactive "sFilename: ")
  (car (split (perl-command "wf" fn) "
"))
  )


(defun vel ()
  (interactive)
  (find-file "/var/log/httpd/error.log")
  (view-mode)
  (goto-char (point-max))
  )


