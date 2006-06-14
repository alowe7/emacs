(put 'addmail 'rcsid
 "$Id: addmail.el,v 1.1 2006-06-14 00:41:57 tombstone Exp $")

(defun addmail (name target)
  "add name as a new virtual email
"
  (interactive "sname: \nstarget: ")

  (shell-command (format "/root/bin/addmail %s %s" name target))
  (message (chomp (chomp (eval-process "tail -n 2 //etc/mail/virtusertable"))))
  )



