(put 'post-midnight 'rcsid
 "$Id$")

(defun cleanup-some-buffers ()
  (interactive)
  (mapc 'kill-buffer (collect-buffers-mode 'dired-mode))
  (mapc 'kill-buffer (collect-buffers-not-modified))
  )

