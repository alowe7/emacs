(put 'mru-shell 'rcsid
 "$Id: mru-shell.el,v 1.5 2005-08-22 20:55:03 cvs Exp $")

(defun mru-shell (arg)
  (interactive "P")
  "grab the most recently used extant shell buffer, pop to it and pushd to the current directory
with numeric prefix ARG, go to that shell, creating it if necessary."


  (let* ((d default-directory)
	 (b
	  (if
	      (and arg (numberp arg))
	      (progn (shell2 arg) (current-buffer))
  ; else
	    (if arg
		(progn (shell) (current-buffer))
	      (let ((l (collect-buffers-mode 'shell-mode)))
		(and l (pop l)))
	      )))
	 )

    (if b 	    
	(let ((w (get-buffer-window b)))
	  (if w (select-window w)
	    (pop-to-buffer b))
	  (end-of-buffer)
	  (unless (string= d default-directory) 
	    (cd d)
	    (comint-send-string (buffer-process) (format "pushd \"%s\"\n" d))
	    )
	  )
  ; if no shells are found, just fire one up
      (call-interactively 'shell)
      )
    )
  )

(global-set-key (vector 'C-return (ctl ?8)) 'mru-shell)
(provide 'mru-shell)
