(put 'clean 'rcsid
 "$Id: clean.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun cleanup-some-buffers ()
  (interactive)
  (mapcar 'kill-buffer (list-buffers-mode 'dired-mode))
  (mapcar 'kill-buffer (list-buffers-not-modified))
  )
