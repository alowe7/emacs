(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2010-01-06 02:31:53 alowe Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

