
; turns out this should be named something other than frame.el
; todo: rename in cvs

; (set-frame-width nil 80)
; (frame-pixel-width nil)
; (screen-width)

(defun tile-frames () (interactive)
  (let* ((width (x-display-pixel-width))
	 (height (x-display-pixel-height))
	 (cols (frame-width))
	 (rows (frame-height))
	 (nframes (length (cdr (current-frame-configuration))))
	 (deltax (/ width nframes))
	 (deltac (/ cols nframes))
	 )


    (loop for f being the frames 
	  with x = 0
	  do 
	  (set-frame-width f deltac)
	  (raise-frame f)
	  (set-frame-position f x 0)
	  (setq x (+ x deltax (* 2 (cdr (assoc 'border-width (frame-parameters f))))))
	  )
    )
  )

  ; (tile-frames)
  ; (loop for f being the frames collect f)
  ; (frame-parameters)

(defun current-frame () (interactive)
  (caadr (current-frame-configuration))
  )

  ; (set-frame-position (current-frame) 0 0)

(defun reset-frame () (interactive)
  (let ((f (current-frame)))
    (set-frame-width f
		     (cdr (assoc 'width default-frame-alist)))
    (set-frame-height f
		      (cdr (assoc 'height default-frame-alist)))

    (raise-frame f)
    (set-frame-position f 			   
			(cdr (assoc 'left default-frame-alist))
			(cdr (assoc 'top default-frame-alist)))
    )
  )


; (tile-frames)
; (reset-frame)
; (maximize-frame)
; (assoc 'top (frame-parameters))
; (assoc 'left (frame-parameters))
; (assoc 'width (frame-parameters))
; (assoc 'height (frame-parameters))


(require 'ctl-x-n)
(define-key ctl-x-3-map "" 'maximize-frame)
(define-key ctl-x-3-map "t" 'tile-frames)

(provide 'frame-helpers)
