(put 'msvc 'rcsid
 "$Id: msvc.el,v 1.1 2001-07-18 22:18:18 cvs Exp $")

(defun msvc-clean () (interactive)
  (fix-dos-file)
  (let ((p (point)))
    (goto-char (point-max))
   (condition-case foo
       (while (> (point) (point-min))
	 (backward-list 1)
	 (c-indent-exp t)
	 )
     (error nil))
    (goto-char p)
    )
  )

(provide 'msvc)
