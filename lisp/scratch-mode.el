(define-derived-mode scratch-mode fundamental-mode "scratch" "")

(defun cleanup-scratch-buffers () (interactive)
  (loop for b in (buffer-list-mode 'scratch-mode) 
	when (= 0 (save-excursion (set-buffer b) (buffer-size))) 
	do (kill-buffer b)
	)
  )

(defun get-scratch-buffer (x)
  (interactive)
  (zap-buffer (make-temp-name x) '(scratch-mode))
  )

(defun pop-to-last-scratch-buffer ()
(let ((b (loop for x being the buffers when (eq (quote scratch-mode) (progn (set-buffer x) major-mode)) return x)))
(if (buffer-live-p b) (pop-to-buffer b) (message "no scratch buffers found"))))
(defun collect-scratch-buffers ()
  (save-excursion
    (loop for x being the buffers when 
	  (and (buffer-live-p x) 
	       (eq (progn (set-buffer x) major-mode)
		   'scratch-mode)
	       )
	  collect x))
  )

(defun roll-scratch-buffers ()
  (interactive)
  (let ((l (collect-scratch-buffers)))
    (roll-buffer-list l)
    )
  )

; todo: factor with bury-buffer (see buffers.el)
(defun unbury-scratch-buffers () 
  (interactive)
  (unless (member last-command '(unbury-scratch-buffers  unbury-scratch-buffers-1))
    (setq *buffer-list-vector* (apply 'vector (collect-scratch-buffers))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 0))
  
  (switch-to-buffer
   (aref *buffer-list-vector* 
	 (setq *buffer-list-vector-index* 
	       (% (1+ *buffer-list-vector-index*)
		  (length *buffer-list-vector*)))))
  )

(defmacro %% (x y)
  "X modulo Y symmetrical around 0"
  (let ((z (eval x)) (w (eval y))) (if (< (% z w) 0) (+ z w) z))
  )

(defun unbury-scratch-buffers-1 () 
  (interactive)
  (unless (member last-command '(unbury-scratch-buffers  unbury-scratch-buffers-1))
    (setq *buffer-list-vector* (apply 'vector (collect-scratch-buffers))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 0))

  (switch-to-buffer 
   (aref *buffer-list-vector*  
	 (setq *buffer-list-vector-index* 
	       (%% (1- *buffer-list-vector-index*)
		   (length *buffer-list-vector*)))))

  )

(global-set-key (vector 'C-M-next) 'unbury-scratch-buffers)
(global-set-key (vector 'C-M-prior) 'unbury-scratch-buffers-1)

(define-key ctl-/-map " " (lambda () (interactive) (roll-buffer-mode 'scratch-mode)))
(define-key ctl-/-map "b" (lambda () (interactive) (list-buffers-mode 'scratch-mode)))

(provide 'scratch-mode)
