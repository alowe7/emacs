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