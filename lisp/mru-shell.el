(put 'mru-shell 'rcsid
 "$Id: mru-shell.el,v 1.3 2004-10-12 21:26:35 cvs Exp $")

(defun mru-shell () (interactive)
  "grab the most recently used extant shell buffer, pop to it and cd to the current directory"
  (let* ((d default-directory)
	 (l (collect-buffers-mode 'shell-mode))
	 (b (and l (pop l)))
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
      )
    )
  )

(global-set-key (vector 'C-return (ctl ?8)) 'mru-shell)
(provide 'mru-shell)
