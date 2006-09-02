(put 'frameplay 'rcsid
 "$Id: frameplay.el,v 1.1 2006-09-02 21:17:16 nathan Exp $")

(defun increment-screen-height (&optional arg) 
  (interactive "p")
  (let ((f (current-frame))
	(h (screen-height))
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
	(h (screen-width))
	(n (or arg 1)))

    (set-frame-width f (+ h n))
    )
  )

(define-key ctl-x-map (vector 'f12) 'increment-screen-height)

(define-key ctl-x-map (vector 'f11) 'increment-screen-width)


