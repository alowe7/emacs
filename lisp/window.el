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

(defun n-windows-horizontally (n) 
  "split into n windows"
  (interactive "nN: ")
  (delete-other-windows)
  (let ((r (/ (window-width (selected-window)) n)))
    (loop for x from 1 to (1- n) do
	  (split-window-horizontally r)
	  (other-window 1)
	  )
    )
  (balance-windows)
  )

(defun three-h ()
  (interactive)
  (n-windows-horizontally 3)
  ; sort window-list by geometry
  (let ((l (sort (window-list) (lambda (x y) (< (car (window-edges x)) (car (window-edges  y)))))))
    (loop for w in l with p = (point-min)
	  do
	  (select-window w)
	  (goto-char p)
	  (recenter 0)
	  (if (re-search-forward page-delimiter nil t) (setq p (point)))
	  )
    )
  )

