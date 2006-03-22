(put 'post-lisp 'rcsid
 "$Id: post-lisp.el,v 1.1 2006-03-22 22:53:33 alowe Exp $")

(defun unbind (thing)
  (interactive (list (read-string* "make unbound (%s): " (thing-at-point (quote word)))))
  (let ((thing (intern thing)))
    (and (boundp thing) (makunbound thing))
    )
  )
(require 'ctl-slash)
(define-key ctl-/-map "u" 'unbind)