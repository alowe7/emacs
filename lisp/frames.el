(put 'frames 'rcsid 
 "$Id: frames.el,v 1.5 2001-02-09 14:29:51 cvs Exp $")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

(require 'advice)



(defadvice switch-to-buffer-other-frame (around 
					 hook-switch-to-buffer-other-frame
					 first activate)

  "advise `switch-to-buffer-other-frame' to create a frame similar in
appearance to the current frame "

  (let* ((exclude '(name buffer-list window-id top left minibuffer))
	 (p (loop for x in (frame-parameters)
		  unless (member (car x) exclude) 
		  collect x)))

  ; just do it.
    ad-do-it

    (modify-frame-parameters nil p)
    )
  )
