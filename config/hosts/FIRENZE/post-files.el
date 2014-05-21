(defun save-buffer-maybe-other-window-context ()
  (interactive)
  (let ((default-directory
	  (if (> (count-windows) 1)
	      (with-current-buffer (window-buffer (next-window (selected-window))) default-directory)
	    default-directory)))
    (call-interactively 'save-buffer))
  )
(define-key ctl-x-4-map "s" 'save-buffer-maybe-other-window-context)
