(put 'lru-shell 'rcsid
 "$Id$")

(require 'buffers)

(defun lru-shell () 
  (interactive)
  "grab the least recently used extant shell buffer, pop to it and cd to the current directory"
  (let* ((d default-directory)
	 (l (reverse (collect-buffers-mode 'shell-mode)))
	 (b (and l (pop l)))
	 )
    (if b (progn
	    (pop-to-buffer b)
	    (goto-char (point-max))
	    (unless (string= d default-directory) 
	      (cd d)
	      (comint-send-string (buffer-process) (format "pushd \"%s\"\n" d))
	      )
	    )
      )
    )
  )


(provide 'lru-shell)

