
(defun show (who) (interactive "swho: ")
  (shell-command (format "run show %s" who))
  )
