(put 'frames 'rcsid "$Id: frames.el,v 1.3 2000-10-03 16:44:06 cvs Exp $")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

