(put 'lnote 'rcsid 
 "$Id: lnote.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")
(require 'log)

(defun lnote (comment &optional buf)
  (interactive "scomment: ")
  (save-excursion 
    (if buf (set-buffer buf))
    (insert
     (format "%s %s\n" 
	     (current-time-string)
	     comment)))
  )