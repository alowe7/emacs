(put 'long-comment 'rcsid "$Id: long-comment.el,v 1.3 2000-10-03 16:44:07 cvs Exp $")
(provide 'long-comment)

(defmacro long-comment (&rest args) "long comment: ignore all arguments unevaluated" nil)


(defalias '/* (symbol-function 'long-comment))
