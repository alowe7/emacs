(put 'flip 'rcsid 
 "$Id: flip.el,v 1.7 2001-07-17 11:14:19 cvs Exp $")

(defun flip (arg)
  "convert contents of buffer from cr-lf to stream-lf format.  
with optional ARG do the opposite"
  (interactive "P")
  (shell-command-on-region 
   (point-min) (point-max)
   (format "flip %s -" (if arg "-d" "")) t t (get-buffer "*Messages*")
   )
  )

(defun flop (fn)
  "convert contents of buffer from stream-lf to cr-lf format.  "
  (interactive "sfn: ")
  (shell-command
   (format "flop %s " fn))
  )

