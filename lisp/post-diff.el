
(defun diff-recovered-file ()
  (interactive)
  (let ((f (format "/tmp/%s" (gensym))))
    (write-region (point-min) (point-max) f)
    (shell-command (concat "diff " f " " (buffer-file-name)))
    (delete-file f)
    )
  )
