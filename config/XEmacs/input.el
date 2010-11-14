
;; overrides for XEmacs

(chain-parent-file)

(defun whack-key-sequence (k)
  (cadr (assoc 
	 (cadr (member 'key (event-properties k)))
	 '((backspace ?))))
  )

(defun read-char-p ()
  (condition-case err
      (read-char)
    (error 
     (whack-key-sequence last-input-event)
     ))
  )
;(read-char-p)
