; 
(require 'scratch-mode) ; where %% lives for now $-)

; this collects buffers with the same name, or if there's only one with this name, collects buffers same mode

(defun default-buffer-like-collector () 
  (let ((l
	 (collect-buffers-named (if (buffer-file-name) (file-name-nondirectory (buffer-file-name)) (buffer-name)))))
    (if (> (length l) 1)
	l
      (collect-buffers-mode major-mode))
    )
  )
(setq buffer-like-collector 'default-buffer-like-collector)

(defun unbury-buffer-like () 
  (interactive)
  (unless (member last-command '(unbury-buffer-like unbury-buffer-like-1))
    (setq *buffer-list-vector* (apply 'vector (funcall buffer-like-collector))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 1))

  (switch-to-buffer 
   (aref *buffer-list-vector*  
	 (setq *buffer-list-vector-index* 
	       (%% (1+ *buffer-list-vector-index*)
		   (length *buffer-list-vector*)))))

  )

(defun unbury-buffer-like-1 () 
  (interactive)
  (unless (member last-command '(unbury-buffer-like unbury-buffer-like-1))
    (setq *buffer-list-vector* (apply 'vector (funcall buffer-like-collector))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 1))

  (switch-to-buffer 
   (aref *buffer-list-vector*  
	 (setq *buffer-list-vector-index* 
	       (%% (1- *buffer-list-vector-index*)
		   (length *buffer-list-vector*)))))

  )

(global-set-key (vector 'C-M-next) 'unbury-buffer-like)
(global-set-key (vector 'C-M-prior) 'unbury-buffer-like-1)
