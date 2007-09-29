(put 'noted 'rcsid
 "$Id: noted.el,v 1.1 2007-09-29 20:57:12 b Exp $")

(defun noted (comment)
  "mark current file as being notable
"

  (interactive "scomment: ")

  (shell-command (format "/root/bin/noted %s\t\"%s\"" (buffer-file-name) comment))
  (message (chomp (chomp (eval-process "tail -n 2 /root/noted"))))
  )


