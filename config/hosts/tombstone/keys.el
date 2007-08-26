(require 'ctl-ret)
(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)


