(defconst rcs-id "$Id: post-info.el,v 1.2 2000-07-30 21:07:47 andy Exp $")
(read-string "post info")

(let ((dir "//neo/info" ))
  (and (host-ok dir t 500)
       (add-to-list 'Info-default-directory-list dir)))

