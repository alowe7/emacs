(defconst rcs-id "$Id: long-comment.el,v 1.2 2000-07-30 21:07:46 andy Exp $")
(provide 'long-comment)

(defmacro long-comment (&rest args) "long comment: ignore all arguments unevaluated" nil)


(defalias '/* (symbol-function 'long-comment))
