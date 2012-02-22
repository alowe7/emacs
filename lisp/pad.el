(put 'pad 'rcsid
 "$Id$")


; like the inverse of trim, I guess

; merge with read-number* from zt and promote

(defun read-number (prompt &optional default)
  "read a number prompting with PROMPT.   
fills with optional default
"
  (loop 
   with n = nil
   do
   (condition-case err
       (let ((s (read-string (format prompt default))))
	 (setq n (or (number* s) default))
	 )
     (error nil))
   until (number* n)
   finally return n
   )
  )
; (read-number "pat do (%d): " (current-column))


(defun pad (target-col &optional beg end)
  (interactive (list (read-number "pad to column (%d): " (current-column))))
  (save-excursion
    (let
	((beg (or beg (point-min))) 
	 (end (or end (1+ (point-max)))))
      (goto-char beg)
      (loop 
       while (< (point) end)
       do
       (end-of-line)
       (if (< (current-column) target-col) (insert (make-string (- target-col (current-column)) ? )))
       (forward-line 1)
       )
      )
    )
  )
