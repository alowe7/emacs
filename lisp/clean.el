(put 'clean 'rcsid
 "$Id$")

(require 'buff)

(defun cleanup-some-buffers ()
  (interactive)
  (mapc 'kill-buffer (list-buffers-mode 'dired-mode))
  (mapc 'kill-buffer (list-buffers-not-modified))
  )

