(put 'frames 'rcsid 
 "$Id$")
;; simple frame abstraction functions

(defun name-frame (name &optional f)
	(interactive "sName: ")
	(modify-frame-parameters 
	 (or f (selected-frame))
	 (list (cons 'name name))))

(require 'advice)


;; this might not be so smart
(defvar *clone-frames* t)
(defvar *clone-frames-offsets* '((top . 10) (left . 10) (width . -5) (height . -2)))

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

      (let* ((frame-parameters (frame-parameters))
	     (p (nconc
		 (loop for x in *clone-frames-offsets* collect 
		       (let ((y (assoc (car x) frame-parameters)))
			 (cond 
			  ((and (numberp (cdr y)) (numberp (cdr x)))
			   (rplacd y (+ (cdr y) (cdr x)))) ; if numbers, add them
			  (t
			   (rplacd y (cdr x))) ; else replace
			  )
			 y)
		       )
		 (loop for x in frame-parameters
		       when (member (car x) *clone-frame-parameters*) 
		       collect x)
		 )
		)
	     )

  ; just do it.
	ad-do-it

  ; special case for postion


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
  (loop for x in (frame-list) do
	(if (not (eq x (selected-frame)))
	    (delete-frame x)))
  )

(defun list-frame-buffers ()
  (save-window-excursion 
    (loop for x in (frame-list)
	  collect 
	  (list x (buffer-name (window-buffer (frame-selected-window x))))
	  )
    )
  )
; (list-frame-buffers)
(defun cadr-equal (a b)
  (string= (cadr a) (cadr b))
  )

(defun delete-duplicate-frames ()
  "delete multiple frames showing the same buffer"
  ; note: really having the same buffer selected
  (interactive)
  (let* ((l  (list-frame-buffers))
	 (m (set-difference l (remove-duplicates l :test 'cadr-equal))))
    (loop for x in m do (delete-frame (car x)))
    )
  )

