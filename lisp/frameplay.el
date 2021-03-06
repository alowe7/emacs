(put 'frameplay 'rcsid
 "$Id$")


(defun increment-screen-height (&optional arg) 
  (interactive "p")
  (let ((f (current-frame))
	(h (frame-height))
	(n (or arg 1)))
    (set-frame-height f (+ h n))
    )
  )

; none of this works right for proportional fonts...
 
(defun maximize-frame () 
  (interactive)
  (let ((f (current-frame))
	(fudge-frame-width (+ (frame-char-width) 4))
	(fudge-frame-height (+ (frame-char-height) 4))
	)

    (set-frame-height (current-frame) (- (/ (display-pixel-height) (frame-char-height)) 4))
    (set-frame-width (current-frame) (- (/ (display-pixel-width) (frame-char-width)) 4))

    (let ((x (max 0 (/ (- (display-pixel-width) (* (frame-width) fudge-frame-width)) 2)))
	  (y (max 0 (/ (- (display-pixel-height) (* (frame-height) fudge-frame-height)) 2))))
      (set-frame-position f x y))

    (raise-frame f)
    )
  )
; (maximize-frame)
; (originate-frame)

(defun originate-frame () (interactive)
  (let ((f (current-frame)))
    (set-frame-position f 0 0))
)
; (originate-frame)


(defun increment-screen-width (&optional arg)
  (interactive "p")
  (let ((f (current-frame))
	(h (frame-width))
	(n (or arg 1)))

    (set-frame-width f (+ h n))
    )
  )

;; suggested use:
; (define-key ctl-x-map (vector 'up) 'increment-screen-height)
; (define-key ctl-x-map (vector 'right) 'increment-screen-width)


