(require 'ctl-ret)

(define-derived-mode scratch-mode fundamental-mode "scratch" "")

(defun cleanup-scratch-buffers ()
  "kills all empty scratch buffers"
  (interactive)
  (loop for b in (collect-buffers-mode 'scratch-mode) 
	when (= 0 (save-excursion (set-buffer b) (buffer-size))) 
	do (kill-buffer b)
	)
  )

(defun get-scratch-buffer (x)
  (interactive)
  (zap-buffer (make-temp-name x) '(scratch-mode))
  )

(defun pop-to-last-scratch-buffer ()
  (interactive)
  (let ((b (loop for x being the buffers when (eq (quote scratch-mode) (progn (set-buffer x) major-mode)) return x)))
    (if (buffer-live-p b) (pop-to-buffer b) (message "no scratch buffers found"))))
(define-key ctl-RET-map "s" 'pop-to-last-scratch-buffer)

(defun collect-scratch-buffers ()
  (save-excursion
    (loop for x being the buffers when 
	  (and (buffer-live-p x) 
	       (eq (progn (set-buffer x) major-mode)
		   'scratch-mode)
	       )
	  collect x))
  )

;; (defun roll-scratch-buffers ()
;;   (interactive)
;;   (let ((l (collect-scratch-buffers)))
;;     (roll-buffer-list l)
;;     )
;;   )

;; alternative version that prompts with some of the buffer contents, since the names are unhelpful
(defun roll-scratch-buffers ()
  (interactive)
  (let ((l (collect-scratch-buffers))
	(x (/ (window-width) 2)))
    (roll-list l 
	       '(lambda (b)
		  (format "%s\t\t%s..." (buffer-name b) (save-excursion (set-buffer b) (tr (buffer-substring (point-min) (min (1- (point-max)) x)) '((?
																		      "\\n"))))))
	       'kill-buffer-1 
	       'switch-to-buffer)
    )
  )
 
; todo: factor with bury-buffer (see buffers.el)
(defun unbury-scratch-buffers () 
  (interactive)
  (unless (member last-command '(unbury-scratch-buffers  unbury-scratch-buffers-1))
    (setq *buffer-list-vector* (apply 'vector (collect-scratch-buffers))
	  *buffer-list-vector-length* (length *buffer-list-vector*)
	  *buffer-list-vector-index* 0))
  
  (if (> (length *buffer-list-vector*) 0)
      (switch-to-buffer
       (aref *buffer-list-vector* 
	     (setq *buffer-list-vector-index* 
		   (%% (1+ *buffer-list-vector-index*)
		      (length *buffer-list-vector*)))))
    (message "no more scratch buffers")
    )
  )

(defmacro %% (x y)
  "X modulo Y symmetrical around 0"
  (let* ((z (eval x)) (w (eval y)) (u (% z w))) (if (< u 0) (+ z w) u))
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

(modify-syntax-entry ?< "(" scratch-mode-syntax-table)
(modify-syntax-entry ?> ")" scratch-mode-syntax-table)

(provide 'scratch-mode)
