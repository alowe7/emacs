(defconst rcs-id "$Id: zap.el,v 1.2 2000-07-30 21:07:49 andy Exp $")
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
