(put 'zap 'rcsid "$Id: zap.el,v 1.3 2000-10-03 16:44:08 cvs Exp $")
(provide 'zap)
;;; 
(defun zap-buffer (bname &optional postop preop)
  "set buffer BUFFER, create if necessary, erase contents if necessary
with optional SEXP, evaluates sexp in context of buffer
"
  (interactive "Bbuffer: ")
; (default-directory "/") 
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
