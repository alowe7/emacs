(put 'flip 'rcsid 
 "$Id: flip.el,v 1.6 2001-04-27 11:38:00 cvs Exp $")

(defun flip (arg)
  "convert contents of buffer from cr-lf to stream-lf format.  
with optional ARG do the opposite"
  (interactive "P")
  (shell-command-on-region 
   (point-min) (point-max)
   (format "flip %s -" (if arg "-d" "")) t t (get-buffer "*Messages*")
   )
  )

