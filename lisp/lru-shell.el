(put 'lru-shell 'rcsid
 "$Id$")

(defun lru-shell () (interactive)
  "grab the least recently used extant shell buffer, pop to it and cd to the current directory"
  (let* ((d default-directory)
	 (l (reverse (collect-buffers-mode 'shell-mode)))
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

(global-set-key (vector 'C-return (ctl ?7)) 'lru-shell)
(provide 'lru-shell)

