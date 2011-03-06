(put 'nautilus 'rcsid
 "$Id: nautilus.el 890 2010-10-04 03:34:24Z svn $")

(require 'process-helpers)

(defun nautilus (&optional dir)
  "start a nautilus process on optional DIR
default is current directory"
  (interactive)
  (let* (
	 (dir (or dir default-directory))
	 (pname (concat "*nautilus " dir "*"))
	 (p (loop for p in (process-list) when (string= pname (process-name p)) return p)))

    (if p
	(message (format "process %s already exists" pname))
      (start-process pname nil "nautilus" dir)
      )
    )
  )

(defun hup-nautilus (&optional dir)
  (interactive)
  (let ((ret (signal-process-like "nautilus" 'hup dir)))
    (debug)

    (if (interactive-p)
	(cond ((null ret) (message "no nautilus process found"))
	      ((eq ret 0) (message "ok"))
	      (t  (message "nautilus error exit")))
      )
    )
  )
; (call-interactively 'hup-nautilus)

(provide 'nautilus)
