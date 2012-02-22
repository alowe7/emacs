(put 'window 'rcsid 
 "$Id$")

(defun top-of-window ()
  (interactive)
  (move-to-window-line 0))

(defun bottom-of-window ()
  (interactive)
  (move-to-window-line (- (window-height) 2)))

(defun three ()
  (interactive)
  (n-windows 3)
  )

(defun n-windows (n) 
  "split into n windows"
  (interactive "nN: ")
  (delete-other-windows)
  (let ((r (/ (window-height (selected-window)) n)))
    (loop for x from 1 to (1- n) do
	  (split-window-vertically r)
	  (other-window 1)
	  )
    )
  (balance-windows)
  )

(defun other-window-1 ()
  (interactive)
  (other-window -1)
  )

