(defconst rcs-id "$Id: lnote.el,v 1.3 2000-07-30 21:07:46 andy Exp $")
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