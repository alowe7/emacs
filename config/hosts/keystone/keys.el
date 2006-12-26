(put 'keys 'rcsid
 "$Id: keys.el,v 1.1 2006-12-26 20:59:47 noah Exp $")

(chain-parent-file t)
(require 'ctl-ret)

(define-key ctl-RET-map "" 'flush-lines)
(define-key ctl-RET-map "" 'keep-lines)
