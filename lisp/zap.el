(put 'zap 'rcsid 
 "$Id: zap.el,v 1.12 2005-01-07 17:36:01 cvs Exp $")
(provide 'zap)
;;; todo -- use (get-buffer-create (generate-new-buffer-name bname))

(defun zap-buffer (bname &optional postop preop)
  "set buffer BUFFER, create if necessary, erase contents if necessary
with optional POSTOP, evaluates POSTOP in context of buffer after creation
with optional PREOP, evaluates PREOP before calling `get-buffer-create'
"
  (interactive "Bbuffer: ")
  (let (v)
    (and preop (eval preop))
  ; if buffer existed and was read only, there's probably little 
  ; utility in keeping it that way, after zapping it!
    (and (buffer-exists-p bname) (kill-buffer bname))
    (setq v (set-buffer (get-buffer-create bname)))
    (and postop (eval postop))
    v)
  )

(defun zap-buffer-0 (bname &optional postop preop)
  "set buffer BUFFER, create if necessary, erase contents if necessary
with optional POSTOP, evaluates POSTOP in context of buffer after creation
with optional PREOP, evaluates PREOP before calling `get-buffer-create'
"
  (interactive "Bbuffer: ")
  (let (v)
    (and preop (eval preop))
  ; if buffer existed and was read only, there's probably little 
  ; utility in keeping it that way, after zapping it!
    (and (buffer-exists-p bname) (kill-buffer bname))
    (setq v (get-buffer-create bname))
    (and postop (eval postop))
    v)
  )


(defun zap-buffer-1 (name)
  "return existing buffer NAME, create if necessary, erase contents if necessary.
see `get-buffer-create'
takes no action and returns nil if buffer exists and is read-only
"
  (interactive "Bbuffer name: ")

  (let ((b (buffer-exists-p name)))
    (if b (save-excursion (set-buffer b) 
			  (condition-case err
			      (progn
				(erase-buffer)
				b)
			    (buffer-read-only 
  ;			     (error " buffer exists: %s" name)
			     nil)
			    ))
      (get-buffer-create name)
      )
    )
  )
; (zap-buffer-1 "foo")

(defun zap-buffer-2 (name)
  "return existing buffer NAME, create if necessary, erase contents if necessary.
see `get-buffer-create'
toggles `buffer-read-only' erases buffer if buffer exists and is read-only

note: leaves focus in the newly created buffer.
"
  (interactive "Bbuffer name: ")

  (let ((b (or (buffer-exists-p name))))
    (if b (progn
	    (set-buffer b) 
	    (setq buffer-read-only nil)
	    (erase-buffer)
	    b)
      (progn
	(set-buffer (get-buffer-create name)))
      )
    )
  )
