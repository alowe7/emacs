(read-string "post info")

(let ((dir "//neo/info" ))
  (and (host-ok dir t 500)
       (add-to-list 'Info-default-directory-list dir)))

