(put 'format 'rcsid
 "$Id$")

(defun format-buffer ()
  (interactive)
  (save-excursion
    (end-of-buffer)
    (while (beginning-of-defun)
      (c-indent-exp t)
      ))
  )