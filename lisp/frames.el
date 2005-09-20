(put 'frames 'rcsid 
 "$Id: frames.el,v 1.11 2005-09-20 21:29:58 cvs Exp $")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

(require 'advice)


;; this might not be so smart
(defvar *clone-frames* t)
(defvar *clone-frame-parameters* '(
				  ; window-id
				  ; top
				  ; left
				  ; buffer-list
				  ; minibuffer
				   width
				   height
				  ; name
				   display
				   visibility
				  ; icon-name
				  ; unsplittable
				  ; modeline
				   background-mode
				   display-type
				   scroll-bar-width
				   cursor-type
				  ; auto-lower
				  ; auto-raise
				   icon-type
				  ; title
				  ; buffer-predicate
				   tool-bar-lines
				   menu-bar-lines
				   line-spacing
				   screen-gamma
				   border-color
				   cursor-color
				   mouse-color
				   background-color
				   foreground-color
				   vertical-scroll-bars
				   internal-border-width
				   border-width
				   font
				   )
  " list of parameters to account for when cloning frames")

(if *clone-frames*
    (defadvice switch-to-buffer-other-frame (around 
					     hook-switch-to-buffer-other-frame
					     last activate)

      "advise `switch-to-buffer-other-frame' to create a frame similar in
appearance to the current frame "

      (let ((p (loop for x in (frame-parameters)
		     when (member (car x) *clone-frame-parameters*) 
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

(defun delete-all-other-frames ()
	(interactive)
	"delete all frames except the currently focused one."
	(dolist (a (frame-list))
		(if (not (eq a (selected-frame)))
				(delete-frame a))))
