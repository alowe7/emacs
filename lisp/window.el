(put 'window 'rcsid 
 "$Id: window.el,v 1.6 2002-02-13 21:48:11 cvs Exp $")

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

(defun replace-in-string (from to str)
  "replace occurrences of REGEXP with TO in  STRING" 
  (save-match-data
    (if (string= from "^")
	(concat to (replace-in-string "
" (concat "
" to) str)) 
      (let (new-str
	    (sp 0)
	    )
	(while (string-match from str sp)
	  (setq new-str (concat new-str (substring str sp (match-beginning 0)) to))
	  (setq sp (match-end 0)))
	(setq new-str (concat new-str (substring str sp)))
	new-str))
    )
  )
