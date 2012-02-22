(put 'format 'rcsid
 "$Id$")

(defun format-buffer ()
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (while (beginning-of-defun)
      (c-indent-exp t)
      ))
  )