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

(provide 'scratch-mode)