(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)

(define-key ctl-RET-map (vector (ctl ? )) 'grep-find)

