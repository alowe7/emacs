;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

