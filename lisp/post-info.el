(put 'post-info 'rcsid 
 "$Id: post-info.el,v 1.4 2000-10-03 16:50:28 cvs Exp $")
(read-string "post info")

(let ((dir "//neo/info" ))
  (and (host-ok dir t 500)
       (add-to-list 'Info-default-directory-list dir)))

