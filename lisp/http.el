(put 'http 'rcsid 
 "$Id: http.el,v 1.1 2000-11-01 15:53:38 cvs Exp $")
(provide 'http)

(defun http-get (url)
  (perl-command "get" url)
  )

