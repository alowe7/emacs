(put 'post-midnight 'rcsid
 "$Id: post-midnight.el,v 1.1 2001-07-18 22:18:18 cvs Exp $")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (list-buffers-mode 'dired-mode))
  (mapcar 'kill-buffer (list-buffers-not-modified))
  )

