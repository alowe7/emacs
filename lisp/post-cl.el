
; stuff which is related to cl

(defmacro pend (x place)
  "(pend X PLACE): insert X at the tail of the list stored in PLACE.
Analogous to (setf PLACE (nconc PLACE X)), though more careful about
evaluating each argument only once and in the right order.  PLACE may
be a symbol, or any generalized variable allowed by `setf'."
  (if (symbolp place) (list 'setq place (list 'nconc place (list 'list x)))
    (list 'callf 'nconc place (list 'list x))))


(defmacro push* (**x** **place**)
  "pushes x onto place iff not already there"
  (let ((*x* (eval **x**))
	(*place* (eval **place**)))
    (or (member *x* *place*)
      (set **place** (cons *x* *place*))
      **place**)
    ))

(defmacro push** (*x* **place**)
  "pushes x onto place iff not already there"
  (let (
	(*place* (eval **place**)))
    (or (member *x* *place*)
      (set **place** (cons *x* *place*))
      **place**)
    ))