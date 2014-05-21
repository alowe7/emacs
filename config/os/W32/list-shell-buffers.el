(defun list-shell-buffers (&optional arg)
  "like buffer list, but only list shell buffers
"

  (interactive "P")

  (list-buffers-mode 'shell-mode)
  )

