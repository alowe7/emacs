(put 'zap 'rcsid 
 "$Id: zap.el,v 1.6 2003-01-25 22:50:59 cvs Exp $")
(provide 'zap)
;;; 
(defun zap-buffer (bname &optional postop preop)
  "set buffer BUFFER, create if necessary, erase contents if necessary
with optional PREOP, evaluates PREOP in context of buffer after creation
with optional POSTOP, evaluates POSTOP before calling `get-buffer-create'
"
  (interactive "Bbuffer: ")
  (let (v)
    (and preop (eval preop))
    (setq v (set-buffer (get-buffer-create bname)))
  ; if buffer existed and was read only, there's probably little 
  ; utility in keeping it that way, after zapping it!
    (setq buffer-read-only nil)
    (erase-buffer)
    (and postop (eval postop))
    v)
  )
