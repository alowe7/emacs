(put 'xdb 'rcsid
 "$Id$")

(chain-parent-file t)

(require 'ctl-slash)

(define-key ctl-RET-map "q" 'xq)
(define-key ctl-RET-map "b" 'txdbi)

(define-key ctl-RET-map "l" 'xl)
(define-key ctl-RET-map "=" 'xl=)
(define-key ctl-RET-map "-" 'xl*)
(define-key ctl-RET-map (vector (ctl ?/)) 'xl/)

(require 'sh)

(if (scan-file-p "~/.private/.xdbrc")
    (setq *txdb-options* (list "-b" ($ "$XDB") "-h" ($ "$XDBHOST"))))
