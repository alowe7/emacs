(put 'post-info 'rcsid "$Id: post-info.el,v 1.3 2000-10-03 16:44:07 cvs Exp $")
(read-string "post info")

(let ((dir "//neo/info" ))
  (and (host-ok dir t 500)
       (add-to-list 'Info-default-directory-list dir)))

