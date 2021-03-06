(put 'eval 'rcsid 
 "$Id$")

(defun inv (v) 
  "insert evaluated lisp expression" 
  (interactive "XLisp Expression: ")
  (insert v))



(defun eval-file (fn)
  (let ((b (get-file-buffer fn)))
    (if b
	(with-current-buffer b
	  (eval-buffer))
      (if (file-exists-p fn) (load fn t t t)))
    )
  )

(defun remq (a l)
  "remove any associations for A in alist L "
  (loop 
   for z in l
   if (not (equal (car z) a))
   collect z))

(defun rremq (v l)
  "remove any associations whose value is for V from alist L "
  (loop 
   for z in l
   if (not (equal (cdr z) v))
   collect z))

(defun vmember (c s) 
  (loop for sc across s thereis  (= c sc)))

(defun setqp (a b)
  (and 
   (boundp a)
   (set a b)
   ))
