(put 'zap-comment 'rcsid
 "$Id: zap-comment.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun zap-comment (&optional arg)
  (interactive "P")

  (if (search-forward "\*" nil t)
      (let ((p (1- (match-beginning 0))))
	(if (search-forward "*/")
	    (progn (kill-region p (match-end 0)) t))))

  )

(defun zap-comments ()
  (interactive)
  (while (zap-comment))
  )
