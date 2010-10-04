(put 'clean 'rcsid
 "$Id$")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (list-buffers-mode 'dired-mode))
  (mapcar 'kill-buffer (list-buffers-not-modified))
  )
