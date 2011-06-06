(chain-parent-file t)

(defun really-kill-process () 
  (interactive)
  (let ((p (get-buffer-process (current-buffer))))
    (condition-case nil
	(progn 
	  (interrupt-process p)
	  (sit-for 1)
	  (delete-process p)
	  )
      (error nil)
      )
    )
  )

; (lookup-key comint-mode-map "")
(define-key comint-mode-map ""  'comint-interrupt-subjob)
(define-key comint-mode-map ""  'really-kill-process)

