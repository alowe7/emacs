(put 'post-midnight 'rcsid
 "$Id: post-midnight.el,v 1.3 2004-05-18 20:11:51 cvs Exp $")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (collect-buffers-mode 'dired-mode))
  (mapcar 'kill-buffer (collect-buffers-not-modified))
  )

