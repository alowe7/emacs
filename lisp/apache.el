(put 'apache 'rcsid 
 "$Id$")
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


