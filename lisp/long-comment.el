(provide 'long-comment)

(defmacro long-comment (&rest args) "long comment: ignore all arguments unevaluated" nil)


(defalias '/* (symbol-function 'long-comment))
