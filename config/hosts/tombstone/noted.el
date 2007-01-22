(put 'noted 'rcsid
 "$Id: noted.el,v 1.2 2007-01-22 21:31:05 tombstone Exp $")

(defun noted (comment)
  "mark current file as being notable
"

  (interactive "scomment: ")

  (shell-command (format "/root/bin/noted %s\t\"%s\"" (buffer-file-name) comment))
  (message (chomp (chomp (eval-process "tail -n 2 /root/noted"))))
  )


