
(defun sc () (interactive)

  (let ((s (eval-process "cmd" "/c" "sc query type= all bufsize= 8096"))
	(b (zap-buffer "*sc*"))
	)
    (insert s)
    (pop-to-buffer b)
    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (local-set-key "\C-m" 'sc-qc)
    )

  )

(defun sc-qc () (interactive)
  (let* ((service
	  (and (save-excursion 
		 (beginning-of-line)
		 (looking-at "SERVICE_NAME: ")
		 (goto-char (match-end 0))
		 (indicated-word))))
	 (qc 
	  (and service
	       (eval-process "cmd" "/c" (format "sc qc %s" service)))))
    (if qc
	(let ((c (current-buffer))
	      (b (zap-buffer (format "*sc qc %s*" service))))
	  (insert qc)
	  (pop-to-buffer b)
	  (beginning-of-buffer)
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only t)
	  (switch-to-buffer c)
	  ))))


