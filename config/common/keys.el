(put 'keys 'rcsid
 "$Id$")

(chain-parent-file t)

(require 'ctl-ret)

(define-key ctl-RET-map "\C-s" 'isearch-thing-at-point)