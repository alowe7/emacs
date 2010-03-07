(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2010-03-07 23:49:08 alowe Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

