(put 'post-reg 'rcsid
 "$Id: post-reg.el,v 1.1 2003-03-31 19:56:45 cvs Exp $")

(defun lsrun (arg) (interactive "P") 
  "show the contents of the windows/currentversion/run key in the machine hive.
with ARG, show the contents of this key from the user hive"
  (if arg
      (lsreg "user" "software/microsoft/windows/currentversion/run")
    (lsreg "machine" "software/microsoft/windows/currentversion/run")
    )
  )
