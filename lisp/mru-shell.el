(put 'mru-shell 'rcsid
 "$Id: mru-shell.el,v 1.2 2004-05-18 20:11:51 cvs Exp $")

(defun mru-shell () (interactive)
  "grab the most recently used extant shell buffer, pop to it and cd to the current directory"
  (let* ((d default-directory)
	 (l (collect-buffers-mode 'shell-mode))
	 (b (and l (pop l)))
	 )
    (if b (progn
	    (pop-to-buffer b)
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
