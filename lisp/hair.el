(defun hair () (interactive)
  (let ((v (read-key-sequence "hairy key sequence:")))
    (setq *last-hair*
	  (cond ((vectorp v) (apply 'vector  (loop for x across v collect (read (hex x))))) (t nil))
	  )
    )
)


; (hair)

; (describe-key (read-key-sequence "hair:"))
