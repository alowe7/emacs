(define-derived-mode scratch-mode fundamental-mode "scratch" "")

(defun cleanup-scratch-buffers () (interactive)
  (loop for b in (buffer-list-mode 'scratch-mode) 
	when (= 0 (save-excursion (set-buffer b) (buffer-size))) 
	do (kill-buffer b)
	)
  )

(provide 'scratch-mode)