(put 'mru-shell 'rcsid
 "$Id$")

(defun mru-shell (arg)
  "grab the most recently used extant shell buffer, pop to it and pushd to the current directory
start up a new shell if necessary.
interactively with prefix ARG, pushd even if that buffer thinks it isn't necessary."
  (interactive "P")


  (let* ((d default-directory)
	 (b (let ((l (collect-buffers-mode 'shell-mode)))
		(and l (pop l)))))

    (if b 	    
	(let ((w (get-buffer-window b)))
	  (if w (select-window w)
	    (pop-to-buffer b))
	  (goto-char (point-max))
	  (when (or arg (not (string= d default-directory) ))
	    (cd d)
	    (comint-send-string (buffer-process) (format "pushd \"%s\"\n" d))
	    )
	  )
  ; if no shells are found, just fire one up
      (call-interactively 'shell)
      )
    )
  )

(provide 'mru-shell)
