(put 'html 'rcsid "$Id: html.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")
(defun clean-html ()
  "extract all html elements from buffer"
  (interactive)
  (while (search-forward-regexp "<[^>]*>" nil t)
					;    (read-string (buffer-substring (match-beginning 0) (match-end 0)))
    (kill-region (match-beginning 0) (match-end 0))
    ))
