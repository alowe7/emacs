
(defun undedicate-window () 
  (interactive)
  (set-window-dedicated-p (selected-window) nil))

