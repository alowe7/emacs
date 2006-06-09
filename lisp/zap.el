(put 'zap 'rcsid 
 "$Id: zap.el,v 1.14 2006-06-09 19:19:04 alowe Exp $")
(provide 'zap)
;;; todo -- use (get-buffer-create (generate-new-buffer-name bname))

;; needed only to get arglist of subrs
(require 'advice)

(defun cardinality (body)
  " like `subr-arity', but works for symbol-functions, lambdas and byte-compiled functions as well as subrs
"
  (length (arglist body))
  )
; (cardinality 'setcdr)
; (cardinality 'html-mode)

(defun arglist (body)
  "wow. all this just to get the arglist...
returns only required args
"
  (cond

   ((and (symbolp body) (fboundp body))
  ; its a function
    (let ((body (symbol-function body)))
      (cond ((symbolp body)
  ; if func is another symbol, recurse
	     (arglist body))
	    (t
	     (let* ((args
		     (copy-list 
		      (cond
		       ((subrp body)
  ; whew boy
			(ad-subr-arglist 'setcdr)
			)
  ; if func is byte compiled, its an array
		       ((byte-code-function-p body)
			(aref body 0))
  ; else its a lambda
		       (t (cadr body)))
		      ))
  ; ignore optional args
		    (pos (and args (position '&optional args))))
	       (cond
		((or (null pos) (< pos 1)) args)
		(t  (progn (setcdr (nthcdr (1- pos) args) nil) args))
		)
	       )
	     )
	    )
      )
    )
   )
  )
; (arglist 'rplacd)
; (arglist 'eval-p)
; (arglist 'zap-buffer)



(defun eval-p (body)
  " eval BODY.  
kludgy special case if  body is a symbol with a function definition of no (required) args, eval the function def"
	       (if (= (length args) 0)
  ; its a function of no args.  call it.
		   (funcall body)
		 )
	       )))))
   (t (eval body))
   )
  )

(defun zap-buffer (bname &optional postop preop)
  "set buffer BUFFER, create if necessary, erase contents if necessary
with optional POSTOP, evaluates POSTOP in context of buffer after creation
with optional PREOP, evaluates PREOP before calling `get-buffer-create'
"
  (interactive "Bbuffer: ")
  (let (v)
    (and preop (eval-p preop))
  ; if buffer existed and was read only, there's probably little 
  ; utility in keeping it that way, after zapping it!
    (and (buffer-exists-p bname) (kill-buffer bname))
    (setq v (set-buffer (get-buffer-create bname)))
    (and postop (eval-p postop))
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
