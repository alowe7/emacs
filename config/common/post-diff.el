(put 'post-diff 'rcsid 
 "$Id$")

(defun diff-recovered-file ()
  (interactive)
  (let ((f (format "/tmp/%s" (gensym))))
    (write-region (point-min) (point-max) f)
    (shell-command (concat "diff " f " " (buffer-file-name)))
    (delete-file f)
    )
  )

(defun diff-windows (arg) (interactive "P")
  (let ((this (buffer-file-name)) (that (save-window-excursion (other-window 1) (buffer-file-name))))
    (diff this that arg)
    )
  )