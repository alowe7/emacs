(put 'xdb 'rcsid
 "$Id: xdb.el,v 1.1 2005-01-18 03:06:06 cvs Exp $")

(chain-parent-file t)

(require 'ctl-slash)

(define-key ctl-/-map "q" 'xq)
(define-key ctl-/-map "t" 'xt)
(define-key ctl-/-map "n" 'xn)
(define-key ctl-/-map "b" 'txdbi)

(define-key ctl-RET-map "l" 'xl)
(define-key ctl-RET-map "=" 'xl=)
(define-key ctl-RET-map "-" 'xl*)
(define-key ctl-RET-map (vector (ctl ?/)) 'xl/)
