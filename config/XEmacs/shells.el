(defun shell-buffers ()
  (loop for x being the buffers 
    when (string-match "^\*shell" (buffer-name x))
    collect x)
  )

(defun unix-canonify (d) (interactive)
(replace-in-string d "\\\\" "/")
)

(defun lru-shell-here ()
  (interactive)
  (let ((dir (unix-canonify default-directory))
	(b (car (last (shell-buffers)))))
    (and b
	 (progn
	   (switch-to-buffer b)
	   (comint-send-string (get-buffer-process (car (shell-buffers))) (format "cd %s\n" dir))
	   (cd dir)
	   )
	 )
    )
  )

(define-key
  ctl-RET-map
  (vector (allocate-event 'key-press '(key ?8 modifiers (control))))
  'lru-shell-here)

; what's up with this?
; (define-key dired-mode-map (vector 'C-return) 'ctl-RET-prefix)