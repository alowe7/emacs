(put 'frames 'rcsid 
 "$Id: frames.el,v 1.7 2004-01-30 14:47:04 cvs Exp $")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

(require 'advice)


;; this might not be so smart
(if nil
(defadvice switch-to-buffer-other-frame (around 
					 hook-switch-to-buffer-other-frame
					 first activate)

  "advise `switch-to-buffer-other-frame' to create a frame similar in
appearance to the current frame "

  (let* ((exclude '(name buffer-list window-id minibuffer))
	 (p (loop for x in (frame-parameters)
		  unless (member (car x) exclude) 
		  collect x)))

  ; just do it.
    ad-do-it

    (modify-frame-parameters nil p)
    )
  )
)

; (if (ad-is-advised 'switch-to-buffer-other-frame) (ad-unadvise 'switch-to-buffer-other-frame))

;; more frame helper functions
(defun select-frame-parameters ()
  "build a default frame alist with selected values from current frame's parameters"
  (interactive)
  (let ((l (loop for x in default-frame-alist
		 collect
		 (cons (car x) (frame-parameter nil (car x))))))
    (setq default-frame-alist l)
    (describe-variable 'default-frame-alist)
    )
  )
