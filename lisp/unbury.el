; 
(require 'scratch-mode) ; where %% lives for now $-)

(defun unbury-buffer-same-name () 
  (interactive)
  (unless (member last-command '(unbury-buffer-same-name unbury-buffer-same-name-1))
    (setq *buffer-list-vector* (apply 'vector (collect-buffers-named (if (buffer-file-name) (file-name-nondirectory (buffer-file-name)) (buffer-name))))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 1))

  (switch-to-buffer 
   (aref *buffer-list-vector*  
	 (setq *buffer-list-vector-index* 
	       (%% (1+ *buffer-list-vector-index*)
		   (length *buffer-list-vector*)))))

  )

(defun unbury-buffer-same-name-1 () 
  (interactive)
  (unless (member last-command '(unbury-buffer-same-name unbury-buffer-same-name-1))
    (setq *buffer-list-vector* (apply 'vector (collect-buffers-named (if (buffer-file-name) (file-name-nondirectory (buffer-file-name)) (buffer-name))))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 1))

  (switch-to-buffer 
   (aref *buffer-list-vector*  
	 (setq *buffer-list-vector-index* 
	       (%% (1- *buffer-list-vector-index*)
		   (length *buffer-list-vector*)))))

  )

(global-set-key (vector 'C-M-next) 'unbury-buffer-same-name)
(global-set-key (vector 'C-M-prior) 'unbury-buffer-same-name-1)
