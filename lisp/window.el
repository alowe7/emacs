(put 'window 'rcsid "$Id: window.el,v 1.3 2000-10-03 16:44:08 cvs Exp $")
(defun top-of-window ()
  (interactive)
  (move-to-window-line 0))

(defun bottom-of-window ()
  (interactive)
  (move-to-window-line (- (window-height) 2)))

(defun three ()
  (interactive)
  (delete-other-windows)
  (let ((n (/ (window-height (selected-window)) 3)))
    (split-window-vertically n)
    (other-window 1)
    (split-window-vertically n))
  )

(defun other-window-1 ()
  (interactive)
  (other-window -1)
  )

(defun replace-in-string (from to str)
  "replace occurrences of REGEXP with TO in  STRING" 
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
