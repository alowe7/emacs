(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2009-11-22 18:37:37 slate Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

