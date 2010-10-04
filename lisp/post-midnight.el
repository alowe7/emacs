(put 'post-midnight 'rcsid
 "$Id$")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (collect-buffers-mode 'dired-mode))
  (mapcar 'kill-buffer (collect-buffers-not-modified))
  )

