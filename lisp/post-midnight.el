(put 'post-midnight 'rcsid
 "$Id: post-midnight.el,v 1.2 2002-03-08 18:35:03 cvs Exp $")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (buffer-list-mode 'dired-mode))
  (mapcar 'kill-buffer (buffer-list-not-modified))
  )

