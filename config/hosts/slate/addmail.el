(put 'addmail 'rcsid
 "$Id$")

(defun addmail (name target)
  "add name as a new virtual email
"
  (interactive "sname: \nstarget: ")

  (shell-command (format "/root/bin/addmail %s %s" name target))
  (message (chomp (chomp (eval-process "tail -n 2 //etc/mail/virtusertable"))))
  )



