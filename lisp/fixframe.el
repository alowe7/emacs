(defun switch-to-buffer-fixed-frame (b)
  (interactive "bswitch to buffer fixed frame: ")
  (let ((default-frame-alist default-frame-alist)
  ;	(*fixed-font* "-raster-courier-normal-r-normal-normal-16-96-120-120-c-90-iso10646-1")
	(*fixed-font* "-*-Courier-*-r-*-*-18-normal-*-*-*-*-*-*-")
	)
    (push (cons 'font  *fixed-font*) default-frame-alist)
    (switch-to-buffer-other-frame b)
    )
  )
; (call-interactively 'switch-to-buffer-fixed-frame)
(define-key ctl-x-5-map "x" 'switch-to-buffer-fixed-frame)
