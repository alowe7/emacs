(put 'advisor 'rcsid
 "$Id: advise.el,v 1.1 2004-03-27 19:03:09 cvs Exp $")

(defun foo () (message default-directory))

(defadvice foo (around 
		hook-foo
		first 
		activate)
  (let ((d default-directory)) (cd "/") ad-do-it (cd d))
  )

; (ad-unadvise 'foo)
; (ad-is-advised 'foo)
; (foo)

