(put 'post-diff 'rcsid 
 "$Id: post-diff.el,v 1.3 2000-10-03 16:50:28 cvs Exp $")

(defun diff-recovered-file ()
  (interactive)
  (let ((f (format "/tmp/%s" (gensym))))
    (write-region (point-min) (point-max) f)
    (shell-command (concat "diff " f " " (buffer-file-name)))
    (delete-file f)
    )
  )
