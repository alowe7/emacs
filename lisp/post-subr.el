;;; post-subr.el --- extensions to `subr'

(defun append-to-list (l m) 
"adds to the value of LIST-VAR the element ELEMENT
like `add-to-list' except if element is added, it is added to the end of the list"
  (unless (member m (eval l)) (set l (append (eval l) (list m))))
  (eval l)
)
; (append-to-list 'load-path 'd)
