(defun view-registers () (interactive)

  (loop for i from 0 to 255 when (get-register i) do 
	(let ((x (current-window-configuration)))
	  (view-register i)
	  (read-char "?")
	  (set-window-configuration x)))
  (message "")

  )