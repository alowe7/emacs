(defconst rcs-id "$Id: frames.el,v 1.2 2000-07-30 21:07:45 andy Exp $")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

