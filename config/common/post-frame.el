; (set-frame-width nil 80)
; (frame-pixel-width nil)
; (screen-width)

(defun tile-frames ()
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