(put 'post-diff 'rcsid 
 "$Id: post-diff.el,v 1.4 2002-12-10 17:22:11 cvs Exp $")

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