(put 'post-comint 'rcsid
 "$Id$")

(chain-parent-file t)

(defun process-tree ()
  ; returns a list of pids like ((parent child)...)
  (let* ((pl (loop for x in (cdr (split (eval-process "ps -aef") "\n")) collect (remove*  "" (split x " ") :test 'string=))))
    (loop for x in pl collect (list (string-to-number (nth 2 x)) (string-to-number (nth 1 x))))
    )
  )
; (process-tree)

(defun child-processes (p)
  ; returns a list of pids like (child ...)
  (let ((pid (process-id p)))   
    (and pid (loop for x in (process-tree) when (= pid (car x)) collect (cadr x) ))
    )
  )

(defun process-by-pid ()
  (loop for x in (process-list) collect (list (process-id x) x))
  )
;  (process-by-pid)

(defun process-from-pid (pid)
  (loop for x in (process-list) when (= (process-id x) pid) return x)
  )
; (process-from-pid 5764)


(defun really-kill-process (&optional process) 
  (interactive)
  (let* ((p (or process (get-buffer-process (current-buffer))))
	 (children (child-processes p))
	 )

  ; if process has a child, kill that instead.
    (cond 
     (children
      (message (eval-process (format "kill -9 %d" (car children)))))
     (t
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
    )
  )

; (lookup-key comint-mode-map "")
(define-key comint-mode-map ""  'really-kill-process)
; (define-key comint-mode-map ""  'comint-interrupt-subjob)

(setq comint-use-prompt-regexp nil)
