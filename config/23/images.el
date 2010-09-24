(put 'view-images 'rcsid
 "$Id: images.el,v 1.2 2010-09-24 01:19:40 alowe Exp $")

(require 'scratch-mode)
(require 'frame-helpers)

(defun switch-to-image-in-frame (imagefile &optional new)
  "switch to scratch buffer showing IMAGEFILE
with optional new frame, create a new frame big enough to hold the image
else resize the current frame
"
  (interactive "fdisplay image file in new frame: ")

  (unless (file-exists-p imagefile) (error "image file %s doesn't exist" imagefile))

  (let* ((img (create-image imagefile))
	 (p (image-size img))
	 (minibuffer-extra 2)
	 (mode-line-extra 1)
	 (width (truncate (car p)))
	 (height
	  (+ minibuffer-extra mode-line-extra (truncate (cdr p))))
	 (b (get-scratch-buffer)))
  ; show image in a scratch buffer in a new frame just the right size
    (set-buffer b)
    (put (intern (buffer-name (current-buffer))) 'image img)
    (insert-image img)
    (select-frame (if new 
		      (make-frame `((width . ,width) (height . ,height)))
		    (progn
		      (set-frame-size (current-frame) width height)
		      (current-frame)  
		      )
		    ))
    (pop-to-buffer b)
    (set-buffer-modified-p nil)
    imagefile
    )
  )

; (switch-to-image-in-frame "/z/el/resources/peak7.jpg")
; (switch-to-image-in-frame "/z/el/resources/peak7.jpg" t)

; (setq img (create-image  "/z/el/resources/peak7.jpg"))
; (image-size img)

(provide 'images)
