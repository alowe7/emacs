(put 'keys 'rcsid
 "$Id: keys.el,v 1.2 2009-11-21 19:09:43 alowe Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

