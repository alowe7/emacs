(put 'noted 'rcsid
 "$Id: noted.el,v 1.1 2006-06-14 00:41:57 tombstone Exp $")

(defun noted (comment)
  "mark current file as being notable
"

  (interactive "scomment: ")

  (shell-command (format "/root/bin/noted %s \"%s\"" (buffer-file-name) comment))
  (message (chomp (chomp (eval-process "tail -n 2 /root/noted"))))
  )


