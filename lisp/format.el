(put 'format 'rcsid
 "$Id: format.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun format-buffer ()
  (interactive)
  (save-excursion
    (end-of-buffer)
    (while (beginning-of-defun)
      (c-indent-exp t)
      ))
  )