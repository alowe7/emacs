(put 'lnote 'rcsid "$Id: lnote.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
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